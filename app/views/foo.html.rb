require 'boilerplate.html'

class Foo < Erector::Widgets::Html5boilerplate
  def main_content
    p 'helloworld from: Foo < Erector::Widgets::Html5boilerplate'
    p "This is #{@bar}."
  end
end