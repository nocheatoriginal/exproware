require "test_helper"
require "selenium/webdriver"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [ 1400, 1400 ] do |driver_options|
    driver_options.add_argument "headless"
    driver_options.add_argument "no-sandbox"
    driver_options.add_argument "disable-gpu"
    driver_options.add_argument "disable-dev-shm-usage"
    driver_options.add_argument "remote-debugging-port=9222"
  end
end