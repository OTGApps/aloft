class CellStylesheet < WindsStylesheet

  BEARING_HEIGHT = 10

  def altitude(st)
    width = 70
    left = st.super_width - width - PADDING

    st.frame = {
      l: left,
      t: PADDING,
      w: width,
      h: st.super_height - (PADDING * 2)
    }
    # st.background_color = UIColor.blueColor
    st.text_alignment = :right
    st.font = font.small
  end

  def azimuth(st)
    size = st.super_height - (2 * PADDING) - BEARING_HEIGHT

    ap size
    st.frame = {
      l: PADDING,
      t: PADDING,
      w: size,
      h: size
    }
    st.tint_color = UIColor.blackColor
    st.content_mode = UIViewContentModeCenter
  end

  def bearing(st)
    size = st.super_height - (2 * PADDING) - BEARING_HEIGHT

    st.frame = {
      l: PADDING,
      t: st.super_height - PADDING - BEARING_HEIGHT,
      w: size,
      h: 10
    }
    st.font = font.tiny
    st.text_alignment = :center
    # st.background_color = UIColor.blueColor
  end

end
