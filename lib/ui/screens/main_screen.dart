import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:ndialog/ndialog.dart';
import 'package:nerdvpn/core/providers/globals/ads_provider.dart';
import 'package:nerdvpn/core/providers/globals/iap_provider.dart';
import 'package:nerdvpn/core/providers/globals/vpn_provider.dart';
import 'package:nerdvpn/core/resources/colors.dart';
import 'package:nerdvpn/core/resources/environment.dart';
import 'package:nerdvpn/core/resources/themes.dart';
import 'package:nerdvpn/core/utils/utils.dart';
import 'package:nerdvpn/ui/components/custom_divider.dart';
import 'package:nerdvpn/ui/components/about_detail.dart';
import 'package:nerdvpn/ui/screens/html_screen.dart';
import 'package:nerdvpn/ui/screens/server_list_screen.dart';
import 'package:nerdvpn/ui/screens/subscription_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/providers/globals/theme_provider.dart';
import '../components/connection_button.dart';
import '../components/custom_image.dart';
import '../components/map_background.dart';
import 'connection_detail_screen.dart';

/// Main screen of the app
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final AdvancedDrawerController _controller = AdvancedDrawerController();

  @override
  void initState() {
    if (Platform.isIOS) {
      AppTrackingTransparency.requestTrackingAuthorization();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      controller: _controller,
      drawer: Stack(
        // Используем Stack для наложения картинки на фон
        children: [
          // Фоновая картинка
          Positioned(
            bottom: 0, // Закрепляем картинку снизу
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/images/chel.png", // Путь к вашей картинке
              fit: BoxFit.cover, // Растягиваем картинку
            ),
          ),
          // Затемнение (опционально)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.5)], // Затемнение снизу
              ),
            ),
            child: ListView( // Основной контент
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("settings", style: Theme.of(context).textTheme.bodySmall).tr(),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.color_lens),
                        title: const Text('theme_mode').tr(),
                        onTap: () => ThemeProvider.read(context).changeThemeMode(context),
                      ),
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: const Text('language').tr(),
                        onTap: () => ThemeProvider.read(context).changeLanguage(context),
                      ),
                      ListTile(
                        leading: const Icon(Icons.update),
                        title: const Text('check_update').tr(),
                        onTap: () => _checkUpdate(),
                      ),
                      const ColumnDivider(space: 20),
                      Text("about_us", style: Theme.of(context).textTheme.bodySmall).tr(),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.privacy_tip),
                        title: const Text('privacy_policy').tr(),
                        onTap: () => startScreen(context, HtmlScreen(title: "privacy_policy".tr(), asset: "assets/html/privacy-policy.html")),
                      ),
                      ListTile(
                        leading: const Icon(Icons.description),
                        title: const Text('terms_of_service').tr(),
                        onTap: () => startScreen(context, HtmlScreen(title: "terms_of_service".tr(), asset: "assets/html/tos.html")),
                      ),
                      ListTile(
                        leading: const Icon(Icons.info),
                        title: const Text('about').tr(),
                        onTap: () => _aboutClick(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: Theme.of(context).brightness == Brightness.dark
                    ? darkBackgroundGradient
                    : lightBackgroundGradient,
              ),
            ),
            ListView(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              children: [
                _appbarWidget(context),
                const ColumnDivider(space: 100),
                const Center(child: ConnectionButton()),
                const ColumnDivider(space: 70),
                _selectVpnWidget(context), // Блок с выбором сервера
                const ColumnDivider(space: 20),
                // Перемещенный блок с картой и кнопкой "Посмотреть больше деталей"
                _connectionInfoWidget(context), // Изменение: Перемещен сюда
                const ColumnDivider(space: 20),
                // Закомментированный блок с рекламой
                // Center(child: AdsProvider.bannerAd(bannerAdUnitID, adsize: AdSize.mediumRectangle)), // Изменение: Закомментировано
                // const ColumnDivider(space: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///Select VPN button, Change the code below if you want to customize the button
  Widget _selectVpnWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => _selectVpnClick(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(color: Theme.of(context).colorScheme.secondary.withOpacity(0.2), blurRadius: 10, spreadRadius: 2, offset: const Offset(0, 5)),
                ],
              ),
              child: Consumer<VpnProvider>(
                builder: (context, vpnProvider, child) {
                  var config = vpnProvider.vpnConfig;

                  final fillColor = Theme.of(context).brightness == Brightness.light
                        ? "#000"
                        : "#fff";

                  return Row(
                    children: [
                      if (config != null)
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: config.flag.contains("http")
                              ? CustomImage(
                            url: config.flag,
                            fit: BoxFit.contain,
                            borderRadius: BorderRadius.circular(5),
                          )
                              : Image.asset("icons/flags/png/${config.flag}.png", package: "country_icons"),
                        ),
                      const SizedBox(width: 10),
                      // Добавляем SVG иконку перед текстом
                      SvgPicture.string(
                        '<svg width="16" height="20" viewBox="0 0 16 20" fill="none" xmlns="http://www.w3.org/2000/svg">'
                            '<path d="M8.00004 4.64758e-05C12.411 4.60901e-05 16 3.58905 16 7.99505C16.029 14.44 8.30404 19.784 8.00004 20C8.00004 20 -0.028958 14.44 4.07537e-05 8.00005C4.03681e-05 3.58905 3.58904 4.68614e-05 8.00004 4.64758e-05ZM8.00004 12C10.21 12 12 10.21 12 8.00005C12 5.79005 10.21 4.00005 8.00004 4.00005C5.79004 4.00005 4.00004 5.79005 4.00004 8.00005C4.00004 10.21 5.79004 12 8.00004 12Z" fill="$fillColor"/>'
                            '</svg>',
                        width: 16,
                        height: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(config?.name ?? 'select_server'.tr(),
                          style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right),
                      const SizedBox(width: 10),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///Connection info widget, Change the code below if you want to customize the widget
  Widget _connectionInfoWidget(BuildContext context) {
    return CupertinoButton(
      onPressed: () => startScreen(context, const ConnectionDetailScreen()),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: primaryColor,
          gradient: const LinearGradient(colors: [primaryColor, secondaryColor], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          boxShadow: [BoxShadow(blurRadius: 20, color: primaryColor.withOpacity(.2))],
          borderRadius: BorderRadius.circular(20),
        ),
        height: 120,
        child: Stack(
          children: [
            //Map background
            const MapBackground(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //Connection info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Consumer<VpnProvider>(
                      builder: (context, value, child) {
                        double bytein = 0;
                        double byteout = 0;
                        if ((value.vpnStatus?.byteIn?.trim().isEmpty ?? false) || value.vpnStatus?.byteIn == "0") {
                          bytein = 0;
                        } else {
                          bytein = double.tryParse(value.vpnStatus!.byteIn.toString()) ?? 0;
                        }

                        if ((value.vpnStatus?.byteOut?.trim().isEmpty ?? false) || value.vpnStatus?.byteIn == "0") {
                          byteout = 0;
                        } else {
                          byteout = double.tryParse(value.vpnStatus!.byteOut.toString()) ?? 0;
                        }

                        return Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: const Text("download", style: TextStyle(color: Colors.white, fontSize: 12)).tr()),
                                      const SizedBox(
                                          width: 30, height: 25, child: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.arrow_downward_rounded, size: 20, color: secondaryColor))),
                                    ],
                                  ),
                                  Text("${formatBytes(bytein.floor(), 0)}/s", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                                ],
                              ),
                            ),
                            Container(height: 50, width: 1, color: Colors.white, margin: const EdgeInsets.symmetric(horizontal: 15)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: const Text("upload", style: TextStyle(color: Colors.white, fontSize: 12)).tr()),
                                      const SizedBox(
                                          width: 50, height: 25, child: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.arrow_upward_rounded, size: 20, color: secondaryColor))),
                                    ],
                                  ),
                                  Text("${formatBytes(byteout.floor(), 0)}/s", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                //Button to see more detail
                Container(
                  color: primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: const Text(
                    "see_more_details",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ).tr(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///Appbar, Change the code below if you want to customize the appbar
  Widget _appbarWidget(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 60,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(child: Text(appName, style: textTheme(context).titleLarge, textAlign: TextAlign.center)),
            Positioned(left: 0, child: IconButton(onPressed: _menuClick, icon: const Icon(Icons.menu))),
            Positioned(
              right: 0,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => _upgradeProClick(context),
                icon: Consumer<IAPProvider>(
                  builder: (context, value, child) {
                    final fillColor = Theme.of(context).brightness == Brightness.light
                        ? "#000"
                        : "#fff";

                    return SvgPicture.string(
                      // Ваш SVG код
                      '''
                      <svg width="34" height="31" viewBox="0 0 34 31" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M27.2 31C27.6817 31 28.0851 30.8346 28.4104 30.504C28.7357 30.1733 28.8989 29.7646 28.9 29.2778C28.9011 28.7909 28.7379 28.3822 28.4104 28.0515C28.0829 27.7209 27.6794 27.5555 27.2 27.5555L6.80001 27.5555C6.31834 27.5555 5.91431 27.7209 5.58791 28.0515C5.26151 28.3822 5.09888 28.7909 5.10001 29.2778C5.10115 29.7646 5.26435 30.1739 5.58961 30.5057C5.91488 30.8375 6.31834 31.0023 6.80001 31L27.2 31ZM26.01 24.9722C26.8317 24.9722 27.561 24.6995 28.1979 24.1541C28.8348 23.6088 29.2247 22.9199 29.3675 22.0875L31.0675 11.1514C31.1242 11.1514 31.1876 11.1588 31.2579 11.1738C31.3282 11.1887 31.3922 11.1956 31.45 11.1944C32.1583 11.1944 32.7601 10.9436 33.2554 10.4418C33.7507 9.94009 33.9989 9.32985 34 8.61111C34.0011 7.89237 33.7529 7.2827 33.2554 6.78211C32.7579 6.28152 32.1561 6.03007 31.45 6.02778C30.7439 6.02548 30.1416 6.27692 29.6429 6.78211C29.1442 7.28729 28.8966 7.89696 28.9 8.61111C28.9 8.81203 28.9215 8.99861 28.9646 9.17083C29.0077 9.34305 29.057 9.50092 29.1125 9.64444L23.8 12.0555L18.4875 4.69306C18.7992 4.46343 19.0542 4.16204 19.2525 3.78889C19.4508 3.41574 19.55 3.01389 19.55 2.58334C19.55 1.86574 19.3018 1.2555 18.8054 0.752616C18.309 0.249727 17.7072 -0.0011428 17 5.40924e-06C16.2928 0.00115362 15.6904 0.252598 15.1929 0.754338C14.6954 1.25608 14.4477 1.86574 14.45 2.58334C14.45 3.01389 14.5492 3.41574 14.7475 3.78889C14.9458 4.16204 15.2008 4.46343 15.5125 4.69306L10.2 12.0555L4.88751 9.64444C4.94418 9.50092 4.99404 9.34305 5.03711 9.17083C5.08018 8.99861 5.10114 8.81204 5.10001 8.61111C5.10001 7.89352 4.85181 7.28328 4.35541 6.78039C3.85901 6.2775 3.25721 6.02663 2.55001 6.02778C1.84281 6.02893 1.24044 6.28037 0.742913 6.78211C0.245381 7.28385 -0.0022538 7.89352 1.21969e-05 8.61111C0.00227819 9.3287 0.249913 9.93894 0.742913 10.4418C1.23591 10.9447 1.83828 11.1956 2.55001 11.1944C2.60668 11.1944 2.67014 11.1876 2.74041 11.1738C2.81068 11.16 2.87471 11.1525 2.93251 11.1514L4.63251 22.0875C4.77418 22.9199 5.16348 23.6088 5.80041 24.1541C6.43735 24.6995 7.16721 24.9722 7.99001 24.9722L26.01 24.9722Z" fill="$fillColor"/>
                      </svg>
                      ''',
                      width: 34,
                      height: 31,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Open the subscription screen when user click on the crown icon
  void _upgradeProClick(BuildContext context) {
    startScreen(context, const SubscriptionScreen());
  }

  ///Open the menu when user click on the menu icon
  void _menuClick() {
    _controller.showDrawer();
  }

  ///Open the server list screen when user click on the select server button
  void _selectVpnClick(BuildContext context) {
    startScreen(context, const ServerListScreen());
  }

  ///Check for update when user click on the update button
  void _checkUpdate() async {
    if (Platform.isAndroid) {
      checkUpdate(context).then((value) {
        if (!value) {
          NAlertDialog(
            title: const Text("update_not_available").tr(),
            content: const Text("update_not_available_content").tr(),
            blur: 10,
            actions: [TextButton(onPressed: () => closeScreen(context), child: const Text("close").tr())],
          ).show(context);
        }
      });
    } else {
      launchUrlString("https://apps.apple.com/app/id$iosAppID");
    }
  }

  ///Open the about dialog when user click on the about button
  void _aboutClick(BuildContext context) {
    const DialogBackground(dialog: AboutScreen(), blur: 10).show(context);
  }
}