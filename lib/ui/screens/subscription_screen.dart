import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/modules.dart';
import 'package:lottie/lottie.dart';
import 'package:ndialog/ndialog.dart';
import 'package:nerdvpn/core/providers/globals/iap_provider.dart';
import 'package:nerdvpn/core/resources/colors.dart';
import 'package:nerdvpn/core/resources/environment.dart';
import 'package:nerdvpn/core/utils/utils.dart';
import 'package:nerdvpn/ui/components/custom_card.dart';
import 'package:nerdvpn/ui/components/custom_divider.dart';
import 'package:provider/provider.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Фон всей вкладки под цвет выбранной темы
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: CloseButton(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black // Цвет для светлой темы
              : Colors.white, // Цвет для тёмной темы
        ),
      ),
      body: Consumer<IAPProvider>(
        builder: (context, value, child) {
          return ListView(
            children: [
              // Текст выше картинки
              Text(
                "Premium",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.bold,
                ),
              ).tr(),
              const ColumnDivider(space: 10),
              Container(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "subscription_title",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
                ).tr(),
              ),

              // Центральная картинка, растянутая на 100% ширины
              SizedBox(
                width: double.infinity, // Растягиваем на всю ширину экрана
                child: Image.asset(
                  'assets/images/premium_img.png', // Замените на путь к вашей картинке
                  fit: BoxFit.cover, // Растягиваем картинку, чтобы она заполнила всё пространство
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CupertinoButton(
                  onPressed: () {
                    // Здесь добавьте логику, которая должна сработать при нажатии на кнопку
                    print("Кнопка 'Купить' нажата");
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10), // Дополнительный отступ для текста
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface, // Цвет фона кнопки
                      borderRadius: BorderRadius.circular(20), // Радиус углов кнопки
                    ),
                    child: Text(
                      "buy_button", // Преобразуем текст в верхний регистр
                      style: TextStyle(
                        color: Colors.white, // Цвет текста
                        fontWeight: FontWeight.bold, // Сделаем текст жирным
                      ),
                    ).tr(),
                  ),
                ),
              ),

              // Текст ниже картинки
              Container(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "subscription_description",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
                ).tr(),
              ),
              const ColumnDivider(space: 20), // Отступ между текстом и кнопками (можно менять высоту)

              // Кнопки подписки
              ...value.productItems.map((e) => _subsButton(value, e)),
              if (Platform.isIOS) ...[
                const ColumnDivider(space: 20), // Отступ между кнопками и кнопкой восстановления (можно менять высоту)
                _restoreButton(value),
              ],
            ],
          );
        },
      ),
    );
  }

  // Виджет для кнопки подписки
  Widget _subsButton(IAPProvider provider, IAPItem e) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        provider.purchase(e);
      },
      child: SizedBox(
        height: 100,
        child: CustomCard(
          margin: const EdgeInsets.symmetric(vertical: 5), // Отступы между кнопками (можно менять)
          showOnOverflow: false,
          child: Stack(
            children: [
              if (subscriptionIdentifier[e.productId]!["featured"])
                const Positioned(
                  right: 0,
                  child: Banner(
                    message: "featured",
                    location: BannerLocation.topEnd,
                    color: primaryColor,
                  ),
                ),
              Center(
                child: ListTile(
                  title: Text(subscriptionIdentifier[e.productId]!["name"]),
                  subtitle: Text(e.description ?? ""),
                  trailing: Text(e.localizedPrice ?? ""),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Виджет для кнопки восстановления покупки
  Widget _restoreButton(IAPProvider provider) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        provider.restorePurchase().showCustomProgressDialog(context).then((value) {
          if (!(value ?? false)) {
            NAlertDialog(
              title: Text("no_restore_title".tr()),
              content: Text("no_restore_description".tr()),
              actions: [
                TextButton(
                  onPressed: () => closeScreen(context),
                  child: Text("understand".tr()),
                ),
              ],
            ).show(context);
          }
        });
      },
      child: Text("restore_purchase".tr()),
    );
  }
}
