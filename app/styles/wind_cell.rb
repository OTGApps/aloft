class CellStylesheet < WindsStylesheet

  BEARING_HEIGHT = 10
  ALTITUDE_WIDTH = 70
  LABEL_WIDTH    = 100

  def altitude(st)
    st.font = font.tiny
    st.text_alignment = :right
    st.resize_to_fit_text

    st.from_bottom = PADDING
    st.from_right = PADDING

    st.background_color = UIColor.blueColor
  end

  def azimuth(st)
    st.content_mode = UIViewContentModeCenter

    st.frame = {
      w: azimuth_size(st),
      h: azimuth_size(st),
      t: PADDING,
      l: PADDING
    }

    st.background_color = UIColor.redColor
  end

  def bearing(st)
    st.font = font.tiny
    st.text_alignment = :center

    st.height = 10
    st.width  = azimuth_size(st)
    st.left        = PADDING
    st.from_bottom = PADDING

    st.background_color = UIColor.orangeColor
  end

  def speed(st)
    left = PADDING + st.super_height + (PADDING * 3)

    st.frame = {
      l: left,
      t: PADDING,
      w: LABEL_WIDTH,
      h: st.super_height - (2 * PADDING)
    }
    st.font = font.medium
    st.text_alignment = :left
    st.background_color = UIColor.greenColor
  end

  def temperature(st)
    st.frame = {
      l: LABEL_WIDTH + st.super_height - (PADDING * 5) - BEARING_HEIGHT,
      t: PADDING,
      w: LABEL_WIDTH,
      h: st.super_height - (2 * PADDING)
    }
    st.font = font.medium
    st.text_alignment = :left
    st.background_color = UIColor.magentaColor
  end

  def azimuth_size(st)
    st.super_height - (2 * PADDING) - BEARING_HEIGHT
  end

end
