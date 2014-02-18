class WindsScreen < PM::TableScreen
  title "Winds Aloft"

  def on_load
    set_attributes self.view, { backgroundColor: UIColor.whiteColor }
    set_nav_bar_right_button UIImage.imageNamed("location-cloud.png"), action: :open_stations
  end

  def on_appear
    open_stations(false, false)
  end

  def open_stations(animated = true, force = true)
    if App::Persistence['station'].nil? || force
      open_modal StationsScreen.new(nav_bar: true), animated: animated
    end
  end

  def table_data
    [{
      cells: [{title:'test'}, {title:'test2'}]
    }]
  end

end
