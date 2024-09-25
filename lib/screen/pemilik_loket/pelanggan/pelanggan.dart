import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moda/components/app_color.dart';
import 'package:moda/components/loading_animation.dart';
import 'package:moda/components/proses_loading.dart';
import 'package:moda/model/pelanggan_model.dart';
import 'package:moda/screen/pemilik_loket/pelanggan/pelanggan_add.dart';
import 'package:moda/service/api_pelanggan_service.dart';

class Pelanggan extends StatefulWidget {
  const Pelanggan({super.key});

  @override
  State<Pelanggan> createState() => _PelangganState();
}

class _PelangganState extends State<Pelanggan> {
  final ApiPelangganService apiPelangganService = ApiPelangganService();
  final List<PelangganModel> _pelanggans = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _isInitialLoading = true;
  bool _allDataLoaded = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchPelanggans(_currentPage);
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

  Future<void> _fetchPelanggans(int page) async {
    if (page == 1) {
      setState(() {
        _isInitialLoading = true;
      });
    }

    try {
      final pelangganRespone = await apiPelangganService.fetchPelanggans(page);

      setState(() {
        if (page == 1) {
          _pelanggans.clear();
        }
        _pelanggans.addAll(pelangganRespone.data);
        _currentPage = pelangganRespone.currentPage + 1;
        _isLoadingMore = false;
        _isInitialLoading = false;
        _allDataLoaded =
            pelangganRespone.currentPage >= pelangganRespone.lastPage;
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
      _fetchPelanggans(_currentPage);
    }
  }

  Future<void> refreshPelanggans() async {
    _pelanggans.clear();
    _currentPage = 1;
    _allDataLoaded = false;
    await _fetchPelanggans(_currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.abus,
      appBar: AppBar(
        title: Text(
          "Pelanggan",
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              color: AppColor.putih,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PelangganAdd(refreshPelanggans),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshPelanggans,
        color: AppColor.accentColor,
        backgroundColor: AppColor.putih,
        child: _isInitialLoading
            ? const Center(child: ProsesLoading())
            : _pelanggans.isEmpty
                ? _buildEmptyState()
                : _buildPelangganList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage('assets/pelanggan.png'),
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 24),
          Text(
            'Belum ada pelanggan',
            style: GoogleFonts.fredoka(
              fontSize: 18,
              color: AppColor.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PelangganAdd(refreshPelanggans),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Tambah Pelanggan',
              style: GoogleFonts.fredoka(color: AppColor.putih),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPelangganList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _pelanggans.length + (_allDataLoaded ? 0 : 1),
      itemBuilder: (context, index) {
        if (index < _pelanggans.length) {
          final pelanggan = _pelanggans[index];
          return _buildPelangganCard(pelanggan, index);
        } else {
          return _buildLoadMoreIndicator();
        }
      },
    );
  }

  Widget _buildPelangganCard(PelangganModel pelanggan, int index) {
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
            pelanggan.nmPenumpang!,
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
                '${pelanggan.noHp}',
                style: GoogleFonts.fredoka(
                  color: AppColor.black.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          trailing: _buildPopupMenu(pelanggan),
        ),
      ),
    );
  }

  Widget _buildPopupMenu(PelangganModel pelanggan) {
    return PopupMenuButton<String>(
      color: AppColor.putih,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onSelected: (value) {
        if (value == 'edit') {
          // Navigator.push(...)
        } else if (value == 'delete') {
          // _showDeleteConfirmationDialog(pelanggan.id!)
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
