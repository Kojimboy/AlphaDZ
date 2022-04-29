Feature: Калькулятор ипотеки
  @test
  Scenario: Расчет ежемесячного платежа

    Given Я перешел на страницу https://calcus.ru/kalkulyator-ipoteki/
    Then Я вижу элементы на странице: заголовок "Ипотечный калькулятор", ссылка "По стоимости недвижимости", ссылка "По сумме кредита", текст "Стоимость недвижимости", текст "Первоначальный взнос", текст "Сумма кредита", текст "Срок кредита", текст "Процентная ставка", текст "Тип ежемесячных платежей"

    When Я ввожу в поле «Стоимость недвижимости» значение "12000000"
    And В выпадающем списке рядом с полем «Первоначальный взнос» выбираю значение "%"
    And В поле «Первоначальный взнос» ввожу значение "20"
    Then Я проверяю, что в разделе «Первоначальный взнос» появился текст "2 400 000 руб."
    And Я проверяю, что «Сумма кредита» равна значению "9 600 000" "руб."

    When В поле «Срок кредита» ввожу значение "20"
    And Я ввожу случайное число от 5 до 12 включительно в поле «Процентная ставка»
    And Я проверяю, что отмечен радиобаттон «Аннуитетные» и не отмечен радиобаттон «Дифференцированные»
    And Я нажимаю на кнопку «Рассчитать»
    # Форма обновилась, ниже появились расчеты платежей
    Then Я проверяю, что значение ежемесячного платежа соответствует значению, рассчитанному по формуле