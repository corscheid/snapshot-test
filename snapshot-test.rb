require 'selenium-webdriver'

def setup
  @driver = Selenium::WebDriver.for :firefox
end

def teardown
  @driver.quit
end

def run
  setup
  yield
  teardown
end

def snap(url_filename)
  File.foreach(url_filename) do |url|
    # skip the line if it's a malformed URL
    if url !~ /^((http|https):\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix
      puts "[INVALID URL] : #{url}"
      next
    end

    @driver.get url

    # setup file name/path for screenshot image
    time = Time.now.strftime('%Y-%m-%d-%H:%M:%S')
    img_path = File.expand_path(File.dirname(__FILE__) + '/screenshots') + '/' + time + '.png'

    @driver.save_screenshot img_path
  end
end

run { snap 'urls.txt' }
