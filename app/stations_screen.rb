class StationsScreen < PM::TableScreen
  title "Weather Stations"

  def on_load
    set_attributes self.view, { backgroundColor: UIColor.whiteColor }
    refresh
  end

  def table_data
    [{
      title: "Select reporting station near you:",
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
        subtitle: "About #{station[:current_distance].miles.round} miles away"
      }
    end
  end

end
