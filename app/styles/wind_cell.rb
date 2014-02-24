class CellStylesheet < WindsStylesheet

  def altitude(st)
    width = 70
    left = st.super_width - width - PADDING

    st.frame = {
      l: left,
      t: PADDING,
      w: width,
      h: st.super_height - (PADDING * 2)
    }
    st.bounds = {l:0, t:0, w:st.frame.size.width, h:st.frame.size.height}
    # st.background_color = UIColor.blueColor
    st.text_alignment = NSTextAlignmentRight
    st.font = font.small
  end

  def azimuth(st)
    size = st.super_height - (2 * PADDING)

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

end
