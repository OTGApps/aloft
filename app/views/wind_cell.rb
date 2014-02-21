class WindCell < PM::TableViewCell

  # This method is used by ProMotion to instantiate cells.
  def initWithStyle(style_name, reuseIdentifier: reuseIdentifier)
    super
    # self.position_label = subview(UILabel, :position_label, styleClass:"position_label")
    # self.addSubview(self.position_label)
    self
  end

  def setup(data_cell, screen)
    cell = super(data_cell, screen)

    # Do Stuff

    cell
  end

end
