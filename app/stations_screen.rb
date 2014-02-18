class StationsScreen < PM::TableScreen
  title "Weather Stations"

  def on_load
    set_attributes self.view, { backgroundColor: UIColor.whiteColor }
    set_nav_bar_button :left, title: "Close", action: :close
    refresh
  end

  def table_data
    [{
      title: "Select weather station near you:",
      cells: stations_close_to_user
    }]
  end

  def refresh
    ap "refreshing"
    BW::Location.get_once do |location|
      ap "got location."
      @location = location
      update_table_data
    end
  end

  def stations_close_to_user
    return [] if @location.nil?

    stations = MotionWinds.sorted_by_distance_from(@location)
    stations.map do |station|
      {
        title: station[:name],
        subtitle: subtitle(station),
        action: :select_station,
        arguments: { station: station }
      }
    end
  end

  def subtitle(station)
    miles = station[:current_distance].miles.round
    state = MotionWinds::State.abbrev(station[:state])
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
