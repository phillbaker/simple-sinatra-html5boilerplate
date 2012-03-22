require 'boilerplate.html'

class Index < Erector::Widgets::Html5boilerplate
  def title
    @title
  end
  def content
    #just add content
    p do
      text @content
    end
  end
end