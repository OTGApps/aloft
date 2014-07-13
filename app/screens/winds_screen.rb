class WindsScreen < PM::TableScreen
  title "Winds Aloft"
  refreshable

  def on_load
    rmq.stylesheet = WindsStylesheet

    view.rmq.apply_style :root_view
    table_view.rmq.apply_style :winds_table

    self.navigationController.navigationBar.translucent = false
    self.automaticallyAdjustsScrollViewInsets = false
    self.edgesForExtendedLayout = UIRectEdgeNone

    set_nav_bar_button :right, image: UIImage.imageNamed('flag'), action: :open_stations
    set_nav_bar_button :left, image: UIImage.imageNamed('settings'), action: :open_about
  end

  def on_appear
    open_stations(false, false)

    if App::Persistence['station']
      setTitle('Winds Aloft', subtitle:"at #{App::Persistence['station']}")
      get_winds
      init_compass
    end
  end

  def init_compass
    if !BW::Location.authorized? || App::Persistence['compass'] == false
      stop_compass
      App.notification_center.post('StopHeadingUpdates', nil)
      return
    end

    BW::Location.get_compass do |heading|
      App.notification_center.post('HeadingUpdate', heading[:magnetic_heading])
    end
  end

  def stop_compass
    BW::Location.stop
  end

  def open_stations(animated = true, force = true)
    if App::Persistence['station'].nil? || force
      open_modal StationsScreen.new(nav_bar: true), animated: animated
    end
  end

  def open_about
    open_modal UINavigationController.alloc.initWithRootViewController(AboutScreen.alloc.init)
  end

  def table_data
    [{
      cells: (wind_heights.enum_for(:each_with_index).map { |k, i| cell(i, k) }) << info_cell
    }]
  end

  def on_refresh ; get_winds ; end

  def cell_height
    @cell_h ||= table_view.size.height / wind_heights.count
  end

  def cell_background_color(index)
    # This creates the pretty blue gradients on the cells.
    %w(18c1e0 29cae9 40d0eb 57d6ed 6edbf0 85e1f2 9ce7f4 b3ecf7 caf2f9)[index].to_color
  end

  def get_winds
    return unless App::Persistence['station']

    Winds.client.at_station(App::Persistence['station']) do |w|
      end_refreshing

      if w.is_a?(NSError)
        Flurry.logEvent("WINDSS_API_ERROR") unless Device.simulator?
        p "Got an error from the winds API"

        App.alert("Error retrieving winds aloft", {
          message: "There was an error retrieving the winds aloft forecasts.\n\nPlease try again or email mark@mohawkapps.com\nfor support."
        })
      else
        @winds = w.last
        @data = w.first
        update_table_data
      end
    end
  end

  # Gets the first 9 altitudes OR the default NOAA heights
  def wind_heights
    if @winds.nil?
      %w(3 6 9 12 18 24 30 34 39).map{ |h| h.to_i * 1000 }.reverse
    else
      @winds.keys.map(&:to_i).reject { |a| a == 0 }.sort[0..8].reverse
    end
  end

  def base_cell
    {
      action: :toggle_metric,
      height: cell_height,
      editing_style: :none,
      selection_style: UITableViewCellSelectionStyleNone,
      cell_class: WindCell,
      style: {
        azimuth: azimuth_image,
        bearing: nil,
        speed: nil,
        temp: nil
      }
    }
  end

  def cell(index, key)
    c = base_cell
    unless @winds.nil?
      data = @winds[key.to_s]
      c[:style].merge!({
        background_color: cell_background_color(index),
        altitude: "#{number_with_delimiter(key)}ft",
        bearing: data['bearing'],
        speed: formatted_speed(data['speed']),
        temperature: formatted_temp(data['temp']),
        light_variable: data['bearing'].nil? && data['speed'].nil?
      })
    else
      c[:style].merge!({
        background_color: cell_background_color(index),
        altitude: "#{number_with_delimiter(key)}ft",
      })
    end
    c
  end

  def info_cell
    data = @winds.nil? ? '' : @winds['raw']
    expiry = @data.nil? ? '' : @data['use'][/[0-9]{3,4}-[0-9]{3,4}Z/]

    {
      title: "Raw data for use #{expiry}",
      cell_class: DataCell,
      subtitle: data,
      editing_style: :none,
      height: 50,
      selection_style: UITableViewCellSelectionStyleNone,
    }
  end

  def toggle_metric
    App::Persistence['metric'] = !App::Persistence['metric']

    flurry_params = {on_off: App::Persistence['metric']}
    Flurry.logEvent("METRIC_SWITCH", withParameters:flurry_params) unless Device.simulator?

    update_table_data
  end

  def formatted_temp(t)
    if App::Persistence['metric'] == true
      t.celcius
    else
      t.fahrenheit
    end
  end

  def formatted_speed(s)
    if App::Persistence['metric'] == true
      s.knots
    else
      s.mph
    end
  end

  def azimuth_image
    @ai ||= 'arrow'.uiimage
  end

  def number_with_delimiter(number)
    number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end

end
