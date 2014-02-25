class CellStylesheet < WindsStylesheet

  BEARING_HEIGHT = 10
  ALTITUDE_WIDTH = 70
  LABEL_WIDTH    = 115

  # Change this value to true to change
  # the background colors of the labels.
  def debug? ; false ; end

  def altitude(st)
    st.font = font.tiny
    st.resize_to_fit_text

    st.from_bottom = PADDING
    st.from_right = PADDING

    st.background_color = UIColor.blueColor if debug?
  end

  def azimuth(st)
    st.content_mode = UIViewContentModeCenter

    st.frame = {
      w: azimuth_size(st),
      h: azimuth_size(st),
      t: PADDING,
      l: PADDING
    }

    st.background_color = UIColor.redColor if debug?
  end

  def bearing(st)
    st.font = font.tiny
    st.text_alignment = :center

    st.height = 10
    st.width  = azimuth_size(st)
    st.left        = PADDING
    st.from_bottom = PADDING

    st.background_color = UIColor.orangeColor if debug?
  end

  def speed(st)
    left = (PADDING * 2) + azimuth_size(st) + PADDING
    st.frame = {
      l: left,
      t: PADDING,
      w: LABEL_WIDTH,
      h: st.super_height - (2 * PADDING)
    }
    st.font = font.medium
    st.text_alignment = :left

    st.background_color = UIColor.greenColor if debug?
  end

  def temperature(st)
    left = (PADDING * 2) + azimuth_size(st) + PADDING + LABEL_WIDTH + PADDING

    st.frame = {
      l: left,
      t: PADDING,
      w: LABEL_WIDTH,
      h: st.super_height - (2 * PADDING)
    }
    st.font = font.medium
    st.text_alignment = :right

    st.background_color = UIColor.magentaColor if debug?
  end

  def azimuth_size(st)
    st.super_height - (2 * PADDING) - BEARING_HEIGHT
  end

end
