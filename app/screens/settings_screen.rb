class SettingsScreen < PM::TableScreen
  include SettingsCells
  include ShareCells
  include OpensourceCells
  include AboutCells
  include DataSourceCells

  title 'Settings'

  def on_load
    set_nav_bar_button :right, title: "Close", action: :close, system_item: :stop
    # Flurry.logEvent("VIEWED_ABOUT") unless Device.simulator?
  end

  def table_data
    [{
      title: "Settings:",
      cells: settings_cells
    }, {
      title: "Share With Your friends:",
      cells: share_cells
    }, {
      title: "#{App.name} is open source:",
      cells: opensource_cells
    }, {
      title: "About #{App.name}:",
      cells: about_cells
    }, {
      title: "Data Source:",
      cells: data_source_cells
    }]
  end
end
