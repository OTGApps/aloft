class WindsScreen < PM::TableScreen
  title "Winds Aloft"

  def on_load
    rmq.stylesheet = WindsStylesheet

    view.rmq.apply_style :root_view
    table_view.rmq.apply_style :winds_table

    self.navigationController.navigationBar.translucent = false
    self.automaticallyAdjustsScrollViewInsets = false
    self.edgesForExtendedLayout = UIRectEdgeNone

    set_nav_bar_right_button UIImage.imageNamed('location-cloud'), action: :open_stations
  end

  def on_appear
    open_stations(false, false)
    get_winds
  end

  def open_stations(animated = true, force = true)
    if App::Persistence['station'].nil? || force
      open_modal StationsScreen.new(nav_bar: true), animated: animated
    end
  end

  def table_data
    return [{cells:[]}] unless @winds
    [{
      cells: wind_heights.enum_for(:each_with_index).map { |k, i| cell(i, k) }
    }]
  end

  def cell_height
    @cell_h ||= (table_view.size.height / wind_heights.count)
    # 100
  end

  def cell_background_color(index)
    percentage = "0.#{index}".to_f
    App.delegate.app_color.lighten(percentage).to_color
  end

  def get_winds
    return unless App::Persistence['station']

    Winds.client.at_station(App::Persistence['station']) do |w|
      @winds = w.last
      update_table_data
    end
  end

  def wind_heights
    @winds.keys.map(&:to_i).sort.reverse
  end

  def cell(index, key)
    data = @winds[key.to_s]
    {
      title: "#{number_with_delimiter(key)} feet",
      subtitle: "#{data['speed']} knots, bearing #{data['bearing']} degrees. (#{data['temp']}°C)",
      background_color: cell_background_color(index),
      height: cell_height,
      editing_style: :none,
      selection_style: UITableViewCellSelectionStyleNone,
      cell_class: WindCell,

      altitude: "#{number_with_delimiter(key)}ft",
      azimuth: UIImage.imageNamed('location-arrow'),
    }
  end

  def number_with_delimiter(number)
    number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end

end
