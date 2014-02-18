class WindsScreen < PM::TableScreen
  title "Winds Aloft"

  def on_load
    set_attributes self.view, { backgroundColor: UIColor.whiteColor }
  end

  def table_data
    [{
      cells: [{title:'test'}, {title:'test2'}]
    }]
  end

end
