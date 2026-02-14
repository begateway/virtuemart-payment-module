# VirtueMart 4 payment plugin

[Click here](https://github.com/beGateway/virtuemart-payment-module/tree/virtuemart-2) to switch to the payment module for VirtueMart 2

[Click here](https://github.com/beGateway/virtuemart-payment-module/tree/virtuemart-3) to switch to the payment module for VirtueMart 3

## Installation

* Backup your webstore and database
* Download from [Github releases page](https://github.com/BeGateway/virtuemart-payment-module/releases) the latest version of the plugin `vmpayment-begateway.zip`
* Start up the administrative panel for Joomla (www.yourshop.com/administrator)
* Choose _Extensions_->_Extension Manager_
* Upload and install the payment module archive via **Upload Package File**.
* Choose _Extensions_->_Plugin Manager_ and find the VM Payment - beGateway plugin and click it.
*	Make sure that its status is set to _Enabled_ and press _Save & Close_.
*	Open _Components_->_VirtueMart_ and select the _Payment methods_.
* Press _New_.
*	Configure it
  * set _Logotype_ of the payment method. Images can be uploaded via _Media Manager_ to the _images/virtuemart/payment_ folder.
  * set _Payment Name_ to _Credit or debit card_
  * set _Sef Alias_ to _begateway_
  * set _Payment Description_ to _Visa_, _Mastercard_. You are free to
    put all payment card supported by your acquiring payment agreement.
  * set _Published_ to _Yes_
  * set _Payment Method_ to _VM Payment - beGateway_
  * click _Save & Close_
*	Open the beGateway payment method and go to _Configuration_. Here you fill in
  * Payment gateway URL, e.g. _demo-gateway.begateway.com_
  * Payment page URL:, e.g. _checkout.begateway.com_
  * Transaction type: _Authorization_ or _Payment_
  * Shop Id, e.g. _361_
  * Shop secret key, e.g. _b8647b68898b084b836474ed8d61ffe117c9a01168d867f24953b776ddcb134d_
  * click _Save & Close_
* Now the module is configured.

## Notes

Tested and developed with VirtueMart 4.6.4

## Testing

You can use the following information to adjust the payment method in test mode:

  * __Shop ID:__ 361
  * __Shop Key:__ b8647b68898b084b836474ed8d61ffe117c9a01168d867f24953b776ddcb134d
  * __Payment gateway URL:__ demo-gateway.begateway.com
  * __Payment page URL:__ checkout.begateway.com

Use the following test card to make successful test payment:

  * Card number: 4200000000000000
  * Name on card: JOHN DOE
  * Card expiry date: 01/30
  * CVC: 123

Use the following test card to make failed test payment:

  * Card number: 4005550000000019
  * Name on card: JOHN DOE
  * Card expiry date: 01/30
  * CVC: 123

## Install sample data

In VM Configuration set Enable database Update tools to yes. Make sure you save.

Go to Tools / Tools & Migration. Hit the "Reset all tables and install sample data" button.

## Contributing

Issue pull requests or send feature requests or open [a new issue](https://github.com/begateway/virtuemart-payment-module/issues/new)

# Платежный модуль VirtueMart 4

Модуль оплаты для VirtueMart 2 находится [здесь](https://github.com/beGateway/virtuemart-payment-module/tree/virtuemart-2)

Модуль оплаты для VirtueMart 3 находится [здесь](https://github.com/beGateway/virtuemart-payment-module/tree/virtuemart-3)

## Установка

* Сделайте резевную копию вашего магазина и базы данных
* Скачайте модуль [begateway.zip](https://github.com/BeGateway/virtuemart-payment-module/raw/master/begateway.zip)
* Скачайте со страницы [Github релизов](https://github.com/BeGateway/virtuemart-payment-module/releases) последнюю версию архива плагина `vmpayment-begateway.zip`
* Зайдите в панель администратора Joomla (www.yourshop.com/administrator)
* Выберите _Расширения_->_Менеджер Расширений_
* Загрузите и установите платежный модуль через **Загрузить файл пакета**.
* Выберите _Расширения_->_Менеджер плагинов_, найдите VM Payment - beGateway плагин и кликните на нем.
*	Убедитесь, что его _Состояние_ установленов в _Включено_ и нажмите _Сохранить и закрыть_.
*	Откройте _Компоненты_->_VirtueMart_ и выберите _Способы оплаты_.
* Нажмите _Создать_.
*	Настройте модуль
  * в _Логотип_ выберите логотип этого способа оплаты. Вы можете
    использовать логотипы, которые предварительно были загружен через _Медия-менеджер_ в каталог _images/virtuemart/payment_.
  * в _Название платежа_ введите _Банковская карта_
  * в _Псевдоним_ введите _begateway_
  * в _Описание платежа_ введите _Visa, Mastercard_
  * в _Опубликовано_ выберите _Да_
  * в _Способ оплаты_ выберите _VM Payment - beGateway_
  * нажмите _Сохранить и закрыть_
*	Откройте способ оплаты _begateway_ и нажмите закладку _Конфигурация_. Здесь необходимо заполнить
  * Адрес платежного шлюза, например, _demo-gateway.begateway.com_
  * Адрес страницы оплаты:, например, _checkout.begateway.com_
  * Тип транзакции: _Оплата_ или _Преавторизация_
  * ID магазина, например, _361_
  * Ключ магазинa, например, _b8647b68898b084b836474ed8d61ffe117c9a01168d867f24953b776ddcb134d_
  * нажмите _Сохранить и закрыть_
* Модуль оплаты настроен.

## Примечания

Протестировано и разработано для VirtueMart 4.6.4

## Тестирование

Вы можете использовать следующие данные, чтобы настроить способ оплаты в тестовом режиме

  * __Идентификационный номер магазина:__ 361
  * __Секретный ключ магазина:__ b8647b68898b084b836474ed8d61ffe117c9a01168d867f24953b776ddcb134d
  * __Адрес платежного шлюза:__ demo-gateway.begateway.com
  * __Адрес страницы оплаты:__ checkout.begateway.com
  * __Режим работы:__ Тестовый

Используйте следующие данные карты для успешного тестового платежа:

  * Номер карты: 4200000000000000
  * Имя на карте: JOHN DOE
  * Месяц срока действия карты: 01/30
  * CVC: 123

Используйте следующие данные карты для неуспешного тестового платежа:

  * Номер карты: 4005550000000019
  * Имя на карте: JOHN DOE
  * Месяц срока действия карты: 01/30
  * CVC: 123

## Нашли ошибку или у вас есть предложение по улучшению расширения?

Создайте пулреквест или [запрос](https://github.com/begateway/virtuemart-payment-module/issues/new)
