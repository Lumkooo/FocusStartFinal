# FocusStartFinal
## iOS проект FocusStart - 2020


В результате выполнения проекта было реализовано приложение по заказу блюд из различных заведений(Фаст-фуд, кафе, рестораны и кофейни) при помощи Firebase. Сделана только пользовательская клиентская часть(приложение по заказу), однако есть возможность реализовать приложение и для стороны, выполняющий эти заказы(то есть для ресторанов/кафе и т.д.). Список заведений и список еды для заведения берется их локальных JSON файлов, список избранных мест и регистрация реализованы при помощи Firebase.

На первой вкладке tabBar-а в виде collectionView реализовано отображение ближайших 20 заведений(если доступна геолокация пользователя). Если же пользователь не разрешил использование местоположения, то просто выдается не отсортированный список 20 заведений. Также на этом экране имеется collectionView для отображения мест, добавленных в список избранных авторизованным пользователем(если пользователь разрешил использование геолокации, то они тоже будут отсортированы по "приближенности"(сначала те, которые ближе) к пользователю) На NavigationBar-е расположена кнопка перехода к поиску, где можно найти интересующее заведение. Также имеется возможность поиска по некоторым категориям(по всем категориям, Фаст-фуд или кофейня).
При нажатии на ячейку collectionView на первой вкладке tabBar-а идет переход к выбранному заведению, где можно посмотреть информацию о нем, его местоположение и перейти к меню этого заведения, где можно выбрать блюдо и добавить его в корзину
На второй вкладке tabBar-а реализована интерактивная карта, где выбирая места по категориям можно смотреть где находится место и переходить к этому месту по нажатию.
На третьей вкладе tabBar-а реализована корзина - список товаров, которые пользователь добавил в корзину для дальнейшей покупки. Оформление заказа доступно только для авторизованных пользователей. При оформлении заказа необходимо выбрать способ доставки и время доставки.
На четвертой вкладке tabBar-а реализован профиль пользователя - регистрация/авторизация(для неавторизованных пользователей) и просмотр сделанных пользователем заказов(если пользователь авторизован).

Если при входе в приложение у пользователя будет отстутствовать интернет соединение, то будет показан экран, уведомляющий его об этом. Приступить к дальнейшей работе можно будет только в случае, если появится инетрнет-соединение. В качестве требований по анимации там была сделана некоторая анимация на время попытки получения сведений о наличии интернет-подключения
Также в качестве анимации был реализован динамический экран загрузки приложения.


### Первый экран TabBar-а:

Список заведений и список любимых мест(место может быть добавлено в "любимые места" только если пользователь авторизован)

![Alt text](ScreenShots/screen1.png)

Поиск заведения(возможен поиск по категориям: по всем категориям/фаст-фуд/кофейни):

![Alt text](ScreenShots/screen13.png)

Экран подробной информации о заведении:

![Alt text](ScreenShots/screen2.png)![Alt text](ScreenShots/screen3.png)

Возможность оценить заведение(доступна только для авторизованных пользователей)

![Alt text](ScreenShots/screen4.png)

Меню заведения:

![Alt text](ScreenShots/screen5.png)![Alt text](ScreenShots/screen6.png)



### Второй экран TabBar-а:

Возможность просмотра заведений по карте и переход к экрану подробной информации о заведении:

![Alt text](ScreenShots/screen7.png)


### Третий экран TabBar-а:

Корзина с добавленными товарами:

![Alt text](ScreenShots/screen8.png)

Процесс оформления заказа:

![Alt text](ScreenShots/screen9.png)



### Четвертый экран TabBar-а:

Экран регистрации/авторизации:

![Alt text](ScreenShots/screen10.png)

Внешний вид экрана пользователя со списком заказов:

![Alt text](ScreenShots/screen11.png)

Информация об одном из заказов в истории заказов:

![Alt text](ScreenShots/screen12.png)




