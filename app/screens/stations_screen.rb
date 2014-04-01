class StationsScreen < PM::TableScreen
  title "Weather Stations"
  refreshable

  def on_load
    rmq.stylesheet = StationsStylesheet
    view.rmq.apply_style :root_view

    @stations = []
    set_nav_bar_button(:left, title: "Close", action: :close) unless App::Persistence['station'].nil?
    refresh
  end

  def table_data
    [{
      title: "Select weather station near you:",
      cells: @stations
    }]
  end

  def on_refresh ; refresh ; end

  def refresh
    ap "refreshing" if BW.debug?
    BW::Location.get_once do |location|
      ap "got location." if BW.debug?
      find_stations(location)
    end
  end

  def find_stations(location)
    ap "Finding stations" if BW.debug?

    end_refreshing
    Stations.client.sorted_by_distance_from(location) do |s|

      if s.is_a?(NSError)
        ap "Got an error from the stations API" if BW.debug?

        App.alert("Error retrieving stations", {
          message: "There was an error retrieving the list of weather stations.\n\nPlease try again or email mark@mohawkapps.com\nfor support."
        })
      else
        map_and_show_stations(s)
      end
    end
  end

  def map_and_show_stations(data)
    @stations = data.map do |station|
      {
        title: station[:name],
        subtitle: subtitle(station),
        action: :select_station,
        height: 60,
        arguments: { station: station }
      }
    end
    update_table_data
  end

  def subtitle(station)
    miles = station[:current_distance].miles.round
    state = station[:state_abbrev]
    "About #{miles} miles away. #{station[:city]}, #{state}"
  end

  def select_station(args = {})
    App::Persistence['station'] = args[:station][:code]
    close
  end

  def close
    dismissModalViewControllerAnimated(true)
  end

end
