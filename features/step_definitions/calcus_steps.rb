Given(/^Открыта страница (.*)$/) do |url|
  @browser.navigate.to url
end

Then(/^Отображаются элементы на странице: заголовок "([^"]*)", ссылка "([^"]*)", ссылка "([^"]*)", текст "([^"]*)", текст "([^"]*)", текст "([^"]*)", текст "([^"]*)", текст "([^"]*)", текст "([^"]*)"$/) do |arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9|
  @browser.find_element(:xpath,"//h1[contains(text(),'#{arg1}')]").displayed?.should == true
  @browser.find_element(:xpath, "//a[contains(text(),'#{arg2}')]").displayed?.should == true #contains для совпадения частичного(если пробелы будут)
  @browser.find_element(:xpath, "//a[contains(text(),'#{arg3}')]").displayed?.should == true
  @browser.find_element(:xpath, "//div[contains(text(),'#{arg4}')]").displayed?.should == true
  @browser.find_element(:xpath, "//div[contains(text(),'#{arg5}')]").displayed?.should == true
  @browser.find_element(:xpath, "//div[contains(@class,'calc-frow type-x type-1')]/div[contains(@class,'calc-fleft')][contains(text(),'#{arg6}')]").displayed?.should == true
  @browser.find_element(:xpath, "//div[contains(@class,'calc-frow calc_type-x calc_type-1 calc_type-3')]//div[contains(@class,'calc-fleft')][contains(text(),'#{arg7}')]").displayed?.should == true
  @browser.find_element(:xpath, "//div[contains(text(),'#{arg8}')]").displayed?.should == true
  @browser.find_element(:xpath, "//div[contains(text(),'#{arg9}')]").displayed?.should == true
end

When(/^Пользователь вводит в поле «Стоимость недвижимости» значение "([^"]*)"$/) do |arg|
  @browser.find_element(:name,'cost').send_keys arg
end

And(/^Пользователь выбирает значение "([^"]*)" в выпадающем списке рядом с полем «Первоначальный взнос»$/) do |arg|
  @browser.find_element(:name,'start_sum_type').find_element(:xpath,"//option[contains(text(),'#{arg}')]").click
end

And(/^Пользователь вводит значение "([^"]*)" в поле «Первоначальный взнос»$/) do |arg|
  @browser.find_element(:name,'start_sum').send_keys arg
end

Then(/^В разделе «Первоначальный взнос» отображается текст "([^"]*)"$/) do |arg|
  @browser.find_element(:xpath, "//div[@class='calc-input-desc start_sum_equiv'][contains((translate(., '\u00a0', ' ')),'#{arg}')]").displayed?.should == true #translate для убирания особого пробела &nbsp
end

And(/^«Сумма кредита» имеет значение "([^"]*)" "([^"]*)"$/) do |arg1, arg2|
  @browser.find_element(:xpath, "//span[@class='credit_sum_value text-muted'][contains((translate(., '\u00a0', ' ')),'#{arg1}')]").displayed?.should == true
  @browser.find_element(:xpath, "//span[@class='calc-input-desc'][contains(text(),'#{arg2}')]").displayed?.should == true

  @sum = @browser.find_element(:xpath, "//span[@class='credit_sum_value text-muted'][contains((translate(., '\u00a0', ' ')),'#{arg1}')]").text.gsub(/\s+/, "").to_i #сохранение значения СУММА КРЕДИТА в переменную int
end

When(/^Пользователь вводит значение "([^"]*)" в поле «Срок кредита»$/) do |arg|
  @browser.find_element(:name,'period').send_keys arg
  @n = arg.to_i * 12 #сохранение кол во месяцев в n
end

And(/^Пользователь вводит случайное число от (\d+) до (\d+) включительно в поле «Процентная ставка»$/) do |arg1, arg2|
  ran =rand(arg1..arg2)
  @browser.find_element(:name,'percent').send_keys ran
  @i = ((ran.to_f/100)/12) #сохранение процентной ставки
end

And(/^Пользователь проверяет, что отмечен радиобаттон «Аннуитетные» и не отмечен радиобаттон «Дифференцированные»$/) do
  @browser.find_element(:id,'payment-type-1').selected?.should == true
  @browser.find_element(:id,'payment-type-2').selected?.should == false
end

And(/^Пользователь нажимает на кнопку «Рассчитать»$/) do
  @browser.find_element(:class,'calc-submit').click
end

Then(/^Значение ежемесячного платежа соответствует значению, рассчитанному по формуле$/) do
  wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  wait.until {@browser.find_element(:xpath,"//div[@class='calc-result-value result-placeholder-monthlyPayment']").displayed?} #Ожидание появления результата
  plata = @browser.find_element(:xpath,"//div[@class='calc-result-value result-placeholder-monthlyPayment']").text
  #plata[","]='.' #заменить запятую на точку
  plata = plata.gsub(/,/, ".").gsub(/\s+/, "").to_f #убрать пробелы и привести текст в float
  puts plata
  formula = @sum * ((@i*((1+@i)**@n))/(((1+@i)**@n)-1))
  puts formula
  plata.should == formula.round(2) #проверка значения с формулой
  sleep  10 #ожидание
end
