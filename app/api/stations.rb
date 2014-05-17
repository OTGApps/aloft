class Stations
  API_URL = "http://winds-aloft.mohawkapps.com/stations"
  # API_URL = "http://winds-aloft-dev.mohawkapps.com/stations"

  def self.client
    Dispatch.once { @instance ||= new }
    @instance
  end

  def all(&block)
    AFMotion::JSON.get(API_URL) do |result|
      json = nil
      error = nil

      if result.success?
        json ||= result.object
      else
        error ||= result.error
      end
      block.call(json, error)
    end
  end

  def sorted_by_distance_from(coordinate, &block)
    coordinate = CLLocation.alloc.initWithLatitude(coordinate[:lat], longitude:coordinate[:lon]) unless coordinate.is_a?(CLLocation)

    all do |json, error|
      if error
        block.call(error)
      else
        # AFNetworking initialised the hash as immutable. Fix that.
        stations = json.map { |s| s.mutableCopy }

        # Get their distnaces
        stations.each do |station|
          station_coord = CLLocation.alloc.initWithLatitude(station[:lat], longitude:station[:lon])
          distance = coordinate.distanceFromLocation(station_coord)
          station[:current_distance] = Distance.new(distance) # In Meters
        end

        block.call(stations.sort_by { |station| station[:current_distance] })
      end
    end
  end

  def sorted_alphabetically(&block)
    all do |json, error|
      if error
        block.call(error)
      else
        # AFNetworking initialised the hash as immutable. Fix that.
        stations = json.map { |s| s.mutableCopy }
        block.call(stations.sort_by { |station| station[:name] })
      end
    end
  end

end
