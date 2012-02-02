class Hello < Erector::Widget
  def content
    #define everything from top
    html do
      head do
        title "Hello"
      end
      body do
        text "Hello, "
        b "world!"
      end
    end
  end
end
