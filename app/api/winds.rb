class Winds
  API_URL = "http://winds-aloft.mohawkapps.com/winds"
  # API_URL = "http://winds-aloft-dev.mohawkapps.com/winds"

  def self.client
    Dispatch.once { @instance ||= new }
    @instance
  end

  def all(&block)
    AFMotion::JSON.get(API_URL) do |result|
      json = nil
      error = nil

      if result.success?
        @json ||= result.object
      else
        @error ||= result.error
      end
      block.call(@json, @error)
    end
  end

  def at_station(station, &block)
    all do |json, error|
      if error
        block.call(error)
      else
        block.call(
          [json['data']].concat(
            json['winds'].find { |k,v| k.downcase == station.downcase }
          )
        )
      end
    end
  end
end
