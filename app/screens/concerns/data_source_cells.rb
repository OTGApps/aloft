module DataSourceCells
  def data_source_cells
    [{
      title: 'Forecast Data from NOAA',
      action: :open_link,
      arguments: {
        url: 'http://aviationweather.gov/products/nws/all',
        flurry_action: 'NOAA_TAPPED'
      }
    # }, {
    #   type: :static_image,
    #   value: 'noaa',
    #   enabled: false,
    #   row_height: 150,
    #   selection_style: :none
    # }, {
    #   type: :text,
    #   row_height: 60,
    #   font: { name: 'HelveticaNeue', size: 12 },
    #   placeholder: 'Logo used with permission. Use of the NOAA logo does not imply endorsement of this app.',
    #   enabled: false,
    #   selection_style: :none
    }]
  end
end
