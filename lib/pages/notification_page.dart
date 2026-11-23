import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _selectedTabIndex = 0; // 0: Semua, 1: Transaksi, 2: Promo

  final List<String> _tabs = ['Semua', 'Transaksi', 'Promo'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E4DB7),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFFFFFFF),
                          Color(0xFFF7F8FE),
                          Color(0xFFE6E8FB),
                          Color(0xFFCDD1F8),
                        ],
                        stops: [0.0, 0.25, 0.65, 1.0],
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        _buildTabNavigation(),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ValueListenableBuilder<List<NotificationItem>>(
                            valueListenable:
                                NotificationService.instance.notificationsNotifier,
                            builder: (context, allItems, _) {
                              final displayList = _getFilteredList();

                              if (displayList.isEmpty) {
                                return _buildEmptyState();
                              }

                              return ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                physics: const BouncingScrollPhysics(),
                                itemCount: displayList.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 20),
                                itemBuilder: (context, index) {
                                  final item = displayList[index];
                                  return _buildNotificationItem(item);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 28,
            ),
            splashRadius: 24,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const Center(
            child: Text(
              'Notifikasi',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabNavigation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedTabIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1B4AB8)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF1B4AB8).withOpacity(0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    _tabs[index],
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF1E2022),
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  List<NotificationItem> _getFilteredList() {
    switch (_selectedTabIndex) {
      case 1:
        return NotificationService.instance.getTransactions();
      case 2:
        return NotificationService.instance.getPromos();
      case 0:
      default:
        return NotificationService.instance.getAll();
    }
  }

  Widget _buildNotificationItem(NotificationItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: Color(0xFF162D69),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              _resolveIcon(item),
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.description,
                style: const TextStyle(
                  fontSize: 12.8,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF2B3649),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _resolveIcon(NotificationItem item) {
    if (item.category == NotificationCategory.promo) {
      if (item.title.toLowerCase().contains('cashback') ||
          item.title.toLowerCase().contains('reward')) {
        return Icons.campaign;
      }
      return Icons.wifi;
    }

    if (item.category == NotificationCategory.sholat) {
      return Icons.access_time_filled_rounded;
    }

    switch (item.transactionType) {
      case TransactionType.ewallet:
        return Icons.account_balance_wallet_rounded;
      case TransactionType.pln:
        return Icons.lightbulb_rounded;
      case TransactionType.qris:
        return Icons.qr_code_2_rounded;
      case TransactionType.pulsa:
      case TransactionType.paketData:
        return Icons.phone_android_rounded;
      case TransactionType.transferBank:
      case TransactionType.transferBca:
        return Icons.swap_horiz_rounded;
      case TransactionType.virtualAccount:
        return Icons.credit_card_rounded;
      case TransactionType.lainnya:
      default:
        return Icons.receipt_long_rounded;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 64,
            color: const Color(0xFF162D69).withOpacity(0.35),
          ),
          const SizedBox(height: 12),
          Text(
            _selectedTabIndex == 1
                ? 'Belum ada transaksi'
                : _selectedTabIndex == 2
                    ? 'Belum ada promo saat ini'
                    : 'Belum ada notifikasi',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF162D69).withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}