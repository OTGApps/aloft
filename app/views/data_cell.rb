class DataCell < PM::TableViewCell
  def layoutSubviews
    super # Remove this call to not draw the title and subtitle elements.
    rmq(self.detailTextLabel).apply_style(:wind_data)
  end
end
