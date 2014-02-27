class WindsStylesheet < ApplicationStylesheet
  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
  end

  def winds_table(st)
    st.separator_style = :none
    st.content_inset = UIEdgeInsetsMake(0, 0, -50, 0)
  end

end
