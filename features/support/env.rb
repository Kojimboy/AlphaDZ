require 'cucumber'
require 'selenium-webdriver'
require 'rspec'

Before  do |scenario|
  caps = Selenium::WebDriver::Chrome::Options.new(args: ['start-maximized']) #на полный экран (добавить 'log-level=3' если раздражают ssl errorы)
  @browser = Selenium::WebDriver.for(:chrome, capabilities: caps)
  @browser.manage.timeouts.implicit_wait = 10 # время если сразу не нашел элемент то ждет 10 сек
end