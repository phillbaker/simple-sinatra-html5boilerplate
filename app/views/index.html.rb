require 'boilerplate.html'

class Index < Erector::Widgets::Html5boilerplate
  def page_title
    @title
  end
  def main_content
    #just add content
    p do
      text @content
    end
  end
end