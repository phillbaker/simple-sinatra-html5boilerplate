require 'base.html'

class Index < Base
  def main_content
    p do
      text @content + "helloworld"
    end
  end
end