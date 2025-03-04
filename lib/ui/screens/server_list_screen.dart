import 'package:easy_localization/easy_localization.dart';
import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nerdvpn/core/https/servers_http.dart';
import 'package:nerdvpn/core/models/vpn_config.dart';
import 'package:nerdvpn/core/resources/colors.dart';
import 'package:nerdvpn/core/resources/environment.dart';
import 'package:nerdvpn/core/utils/preferences.dart';
import 'package:nerdvpn/ui/components/server_item.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

/// Server list screen
class ServerListScreen extends StatefulWidget {
  const ServerListScreen({super.key});

  @override
  State<ServerListScreen> createState() => _ServerListScreenState();
}

class _ServerListScreenState extends State<ServerListScreen> with SingleTickerProviderStateMixin {
  final List<RefreshController> _refreshControllers = List.generate(2, (index) => RefreshController(initialRefresh: !cacheServerList));
  List<VpnConfig> _servers = [];
  late TabController _tabController; // Контроллер для управления вкладками

  @override
  void initState() {
    super.initState();

    // Инициализация TabController
    _tabController = TabController(length: 2, vsync: this);

    ServicesBinding.instance.addPostFrameCallback((timeStamp) {
      if (cacheServerList) {
        Preferences.instance().then((value) {
          if (value.loadServers().isNotEmpty && mounted) {
            setState(() {
              _servers = value.loadServers();
            });
          } else {
            loadData();
          }
        });
      } else {
        loadData();
      }
    });
  }

  @override
  void dispose() {
    for (var element in _refreshControllers) {
      element.dispose();
    }
    _tabController.dispose(); // Освобождаем ресурсы TabController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: const Text('server_list').tr(),
            floating: true,
            pinned: true,
            forceElevated: innerBoxIsScrolled,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: _serversTab(), // Используем кастомный виджет для вкладок
            ),
          ),
        ],
        body: ExtendedTabBarView(
          controller: _tabController, // Передаем контроллер в ExtendedTabBarView
          children: List.generate(2, (index) {
            var data = _servers.where((e) => e.status == index).toList();
            return SmartRefresher(
              onRefresh: loadData,
              controller: _refreshControllers[index],
              child: ListView(
                addAutomaticKeepAlives: true,
                padding: EdgeInsets.zero,
                children: List.generate(data.length, (index) => ServerItem(data[index])),
              ),
            );
          }),
        ),
      ),
    );
  }

  // Кастомный виджет для вкладок
  Widget _serversTab() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Row(
        children: [
          // Кнопка для стандартных серверов
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _tabController.index = 0; // Переключаем на первую вкладку
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 5), // Расстояние между кнопками
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _tabController.index == 0 ? Theme.of(context).colorScheme.surface : Colors.transparent, // Заливка для выбранного сервера
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface, // Цвет бордера
                    width: 1, // Толщина бордера
                  ),
                  borderRadius: BorderRadius.circular(20), // Радиус бордера
                ),
                child: Center(
                  child: Text(
                    'standard_servers'.tr(),
                  ),
                ),
              ),
            ),
          ),

          // Кнопка для премиум серверов
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _tabController.index = 1; // Переключаем на вторую вкладку
                });
              },
              child: Container(
                margin: const EdgeInsets.only(left: 5), // Расстояние между кнопками
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _tabController.index == 1 ? Theme.of(context).colorScheme.surface : Colors.transparent, // Заливка для выбранного сервера
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface, // Цвет бордера
                    width: 1, // Толщина бордера
                  ),
                  borderRadius: BorderRadius.circular(20), // Радиус бордера
                ),
                child: Center(
                  child: Text(
                    'premium_servers'.tr(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void loadData() async {
    List<VpnConfig> resp = await ServersHttp(context).allServers().then((value) {
      for (var element in _refreshControllers) {
        element.refreshCompleted();
        element.loadComplete();
      }
      if (cacheServerList) {
        Preferences.instance().then((pref) {
          pref.saveServers(value: value);
        });
      }
      return value;
    }).catchError((e) {
      for (var element in _refreshControllers) {
        element.refreshFailed();
      }
      return <VpnConfig>[];
    });
    if (mounted) {
      setState(() {
        _servers = resp;
      });
    }
  }
}