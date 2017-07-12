class StationsScreen < PM::TableScreen
  title "Weather Stations"
  refreshable
  searchable

  def on_refresh ; refresh ; end
  def on_appear ; refresh ; end

  def on_load
    rmq.stylesheet = StationsStylesheet
    view.rmq.apply_style :root_view

    @stations = []
    unless App::Persistence['station'].nil?
      set_nav_bar_button(
        :right,
        title: 'Close',
        system_item: :stop,
        action: :close
      )
    end
  end

  def table_data
    [{
      title: "Select weather station near you:",
      cells: @stations
    }]
  end

  def refresh
    p "refreshing"
    # Flurry.logEvent("REFRESH_STATIONS") unless Device.simulator?

    BW::Location.get_once(purpose: 'To find the closest NOAA weather station.') do |location|
      mp "Got location: #{location}"
      if location.is_a?(CLLocation)
        p "got location."
        find_stations(location)
      else
        find_stations
      end
    end
  end

  def found_stations(s)
    if s.is_a?(NSError)
      p "Got an error from the stations API"
      # Flurry.logEvent("STATIONS_API_ERROR") unless Device.simulator?

      App.alert("Error retrieving stations", {
        message: "There was an error retrieving the list of weather stations.\n\nPlease try again in a minute."
      })
    else
      map_and_show_stations(s)
    end
  end

  def find_stations(location=nil)
    p "Finding stations"

    if location.nil?
      Stations.client.sorted_alphabetically do |s|
        end_refreshing
        found_stations(s)
      end
    else
      Stations.client.sorted_by_distance_from(location) do |s|
        end_refreshing
        found_stations(s)
      end
    end
  end

  def map_and_show_stations(data)
    @stations = data.map do |station|
      {
        title: station[:name],
        subtitle: subtitle(station),
        search_text: "#{station[:name]} #{station[:code]}",
        action: :select_station,
        height: 60,
        arguments: { station: station }
      }
    end
    update_table_data
  end

  def subtitle(station)
    state = station[:state_abbrev]
    city_state = "#{station[:city]}, #{state}"
    return city_state if station[:current_distance].nil?

    if App::Persistence['metric'] == true
      distance = station[:current_distance].kilometers.round
      distance_word = 'km'
    else
      distance = station[:current_distance].miles.round
      distance_word = ' miles'
    end

    "#{station[:code]} - About #{distance}#{distance_word} away. #{city_state}"
  end

  def select_station(args = {})
    App::Persistence['station'] = args[:station][:code]

    # flurry_params = {station: args[:station][:code]}
    # Flurry.logEvent("SELECTED_STATION", withParameters:flurry_params) unless Device.simulator?

    close
  end

  def close
    dismissModalViewControllerAnimated(true)
  end
end
