class WindsScreen < PM::TableScreen
  title "Winds Aloft"

  def on_load
    # set_attributes self.view, { backgroundColor: UIColor.whiteColor }
    set_nav_bar_right_button UIImage.imageNamed('location-cloud'), action: :open_stations

    set_attributes table_view, {
      scroll_enabled: false,
      separatorStyle: UITableViewCellSeparatorStyleNone
    }
    self.navigationController.navigationBar.translucent = false
    self.automaticallyAdjustsScrollViewInsets = false
    self.edgesForExtendedLayout = UIRectEdgeNone
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
      cells: wind_heights.enum_for(:each_with_index).map { |h, i| cell(i, h, 12, 270) }
    }]
  end

  def cell_height
    @cell_h ||= (table_view.size.height / wind_heights.count)
  end

  def cell_background_color(index)
    percentage = "0.#{index+2}".to_f
    App.delegate.app_color.lighten(percentage).to_color
  end

  def wind_heights
    %w(3000 6000 12000 18000 24000 30000 34000 39000).reverse
  end

  def cell(index, height, speed, bearing)
    {
      title: "#{height} feet",
      subtitle: "#{speed} knots, bearing #{bearing} degrees.",
      altitude: "#{height}",
      background_color: cell_background_color(index),
      height: cell_height,
      editing_style: :none,
      selection_style: UITableViewCellSelectionStyleNone,
      cell_class: WindCell,
    }
  end

end
