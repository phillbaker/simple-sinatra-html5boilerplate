require 'boilerplate.html'
#TODO get rid of having to rename on file change 
# maybe something like use 'boilerplate.html' do ... end ? => class XX < Erector::Widgets:: ... end ? 
# (do something like Sinatra, with evaling all the methods on an object?)
class Index < Erector::Widgets::Html5boilerplate
  def page_title
    @title
  end
  def main_content
    #just add content
    p do
      text @content + "hello"
    end
  end
end