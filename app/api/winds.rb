class Winds
  API_URL = "http://winds-aloft.mohawkapps.com/winds"

  def self.client
    Dispatch.once { @instance ||= new }
    @instance
  end

  def all(&block)
    return block.call(@json, @error) if @json

    AFMotion::JSON.get(API_URL) do |result|
      json = nil
      error = nil

      if result.success?
        @json ||= result.object
      else
        @error ||= result.error
      end
      block.call @json, @error
    end
  end

  def at_station(station, &block)
    all do |json, error|
      block.call(json['winds'].find { |k,v| k.downcase == station.downcase })
    end
  end
end
