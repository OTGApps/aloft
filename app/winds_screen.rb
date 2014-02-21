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
      cells: %w(3000 6000 12000 18000 24000 30000 34000 39000).map { |h| cell(h, 12, 270) }
    }]
  end

  def cell(height, speed, bearing)
    {
      title: "#{height} feet",
      subtitle: "#{speed} knots, bearing #{bearing} degrees."
    }
  end

end
