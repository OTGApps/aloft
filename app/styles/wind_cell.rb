class CellStylesheet < WindsStylesheet

  def altitude(st)
    container = cell_size(st)
    width = 70
    left = container.width - width - PADDING

    st.frame = {
      l: left,
      t: PADDING,
      w: width,
      h: container.height - (PADDING * 2)
    }
    # st.background_color = UIColor.blueColor
    st.text_alignment = NSTextAlignmentRight
  end

  # def azimuth(st)
  #   st.frame = {
  #     l: PADDING,
  #     t: PADDING,
  #     w: 90,
  #     h: container.height
  #   }
  # end

  # Calculates the containing view's size
  def cell_size(st)
    @cs ||= st.superview.frame.size
  end

end
