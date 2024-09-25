import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moda/components/app_color.dart';
import 'package:moda/components/loading_animation.dart';
import 'package:moda/components/proses_loading.dart';
import 'package:moda/model/paket_model.dart';
import 'package:moda/service/api_paket_service.dart';

class Paket extends StatefulWidget {
  const Paket({super.key});

  @override
  State<Paket> createState() => _PaketState();
}

class _PaketState extends State<Paket> {
  final ApiPaketService apiPaketService = ApiPaketService();
  final List<PaketModel> _pakets = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _isInitialLoading = true;
  bool _allDataLoaded = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchPakets(_currentPage);
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (!_isLoadingMore && !_allDataLoaded) {
        _loadMoreData();
      }
    }
  }

  Future<void> _fetchPakets(int page) async {
    if (page == 1) {
      setState(() {
        _isInitialLoading = true;
      });
    }

    try {
      final paketResponse = await apiPaketService.fetchPakets(page);

      setState(() {
        if (page == 1) {
          _pakets.clear();
        }
        _pakets.addAll(paketResponse.data);
        _currentPage = paketResponse.currentPage + 1;
        _isLoadingMore = false;
        _isInitialLoading = false;
        _allDataLoaded = paketResponse.currentPage >= paketResponse.lastPage;
      });
    } catch (error) {
      print('Error: $error');
      setState(() {
        _isLoadingMore = false;
        _isInitialLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan saat memuat data')),
      );
    }
  }

  void _loadMoreData() {
    if (!_isLoadingMore && !_allDataLoaded) {
      setState(() {
        _isLoadingMore = true;
      });
      _fetchPakets(_currentPage);
    }
  }

  Future<void> refreshPakets() async {
    _pakets.clear();
    _currentPage = 1;
    _allDataLoaded = false;
    await _fetchPakets(_currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.abus,
      appBar: AppBar(
        title: Text(
          "Paket",
          style: GoogleFonts.fredoka(
            fontSize: 25.0,
            color: AppColor.putih,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppColor.putih,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refreshPakets,
        color: AppColor.accentColor,
        backgroundColor: AppColor.putih,
        child: _isInitialLoading
            ? const Center(child: ProsesLoading())
            : _pakets.isEmpty
                ? _buildEmptyState()
                : _buildPaketList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage('assets/paket.png'),
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 24),
          Text(
            'Belum ada paket',
            style: GoogleFonts.fredoka(
              fontSize: 18,
              color: AppColor.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPaketList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _pakets.length + (_allDataLoaded ? 0 : 1),
      itemBuilder: (context, index) {
        if (index < _pakets.length) {
          final paket = _pakets[index];
          return _buildPaketCard(paket, index);
        } else {
          return _buildLoadMoreIndicator();
        }
      },
    );
  }

  Widget _buildPaketCard(PaketModel paket, int index) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: AppColor.putih,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: CircleAvatar(
            backgroundColor: AppColor.accentColor,
            radius: 20.0,
            child: Text(
              '${index + 1}',
              style: GoogleFonts.fredoka(
                color: AppColor.putih,
                fontSize: 18.0,
              ),
            ),
          ),
          title: Text(
            paket.noPaket!,
            style: GoogleFonts.fredoka(
              color: AppColor.black,
              fontSize: 18,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Penerima ${paket.nmPenerima}',
                style: GoogleFonts.fredoka(
                  color: AppColor.black.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              Text(
                'Hp Penerima ${paket.noHpPenerima}',
                style: GoogleFonts.fredoka(
                  color: AppColor.black.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          trailing: _buildPopupMenu(paket),
        ),
      ),
    );
  }

  Widget _buildPopupMenu(PaketModel paket) {
    return PopupMenuButton<String>(
      color: AppColor.putih,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onSelected: (value) {
        if (value == 'edit') {
          // Navigator.push(...)
        } else if (value == 'delete') {
          // _showDeleteConfirmationDialog(paket.id!)
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'edit',
          child: ListTile(
            leading: const Icon(Icons.edit, color: AppColor.backgroundColor),
            title: Text(
              'Edit',
              style: GoogleFonts.fredoka(
                fontSize: 14,
                color: AppColor.black,
              ),
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: Text(
              'Delete',
              style: GoogleFonts.fredoka(
                fontSize: 14,
                color: AppColor.black,
              ),
            ),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: AppColor.accentColor),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return _isLoadingMore
        ? const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: LoadingAnimation()),
          )
        : Container();
  }
}
