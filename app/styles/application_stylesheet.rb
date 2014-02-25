class ApplicationStylesheet < RubyMotionQuery::Stylesheet
  PADDING = 3

  def application_setup
    font_family = 'Helvetica Neue'
    font.add_named :large,    font_family, 36
    font.add_named :medium,   font_family, 24
    font.add_named :small,    font_family, 18
    font.add_named :tiny,     font_family, 11

    color.add_named :sky_blue,   '#15adca'
  end

  def label(st)
    st.background_color = color.clear
  end

end
