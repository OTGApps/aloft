class WindsScreen < PM::TableScreen
  title "Winds Aloft"

  def on_load
    set_attributes self.view, { backgroundColor: UIColor.whiteColor }
  end

  def on_appear
    open_modal StationsScreen.new(nav_bar: true), animated: false unless App::Persistence['station']
  end

  def table_data
    [{
      cells: [{title:'test'}, {title:'test2'}]
    }]
  end

end
