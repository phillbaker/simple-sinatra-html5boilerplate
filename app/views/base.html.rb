require 'boilerplate.html'

class Base < Erector::Widgets::Html5boilerplate
  def description
    "@app_desc.capitalize"
  end
  def author
    'phillbaker.com'
  end
  def page_title
    @title
  end
  def container_classes
    [:container]
  end
  def header_content
    a :href => '/' do
      h1 "@app_name"
    end
    h2 "@app_desc"
  end
  def main_content
    p do
      text @content + "hello"
    end
  end
  
  def footer_content
    text "© #{Time.now.year.to_s} - A "
    a 'phillbaker production', :href => 'http://phillbaker.com/'
  end
end