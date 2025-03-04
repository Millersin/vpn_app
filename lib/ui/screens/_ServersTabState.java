class _ServersTabState extends State<ServersTab> {
  bool isStandardSelected = true; // По умолчанию выбран "Стандартные серверы"

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          // Кнопка для стандартных серверов
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isStandardSelected = true; // Выбор "Стандартные серверы"
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 5), // Расстояние между кнопками
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isStandardSelected ? primaryColor : Colors.transparent, // Заливка для выбранного сервера
                  border: Border.all(
                    color: Colors.white, // Цвет бордера
                    width: 1, // Толщина бордера
                  ),
                  borderRadius: BorderRadius.circular(20), // Радиус бордера
                ),
                child: Center(
                  child: Text(
                    'standard_servers'.tr(),
                    style: TextStyle(
                      color: isStandardSelected ? Colors.white : Colors.white, // Цвет текста
                    ),
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
                  isStandardSelected = false; // Выбор "Премиум серверы"
                });
              },
              child: Container(
                margin: const EdgeInsets.only(left: 5), // Расстояние между кнопками
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !isStandardSelected ? primaryColor : Colors.transparent, // Заливка для выбранного сервера
                  border: Border.all(
                    color: Colors.white, // Цвет бордера
                    width: 1, // Толщина бордера
                  ),
                  borderRadius: BorderRadius.circular(20), // Радиус бордера
                ),
                child: Center(
                  child: Text(
                    'premium_servers'.tr(),
                    style: TextStyle(
                      color: !isStandardSelected ? Colors.white : Colors.white, // Цвет текста
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}