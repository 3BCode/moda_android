import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moda/components/app_color.dart';
import 'package:moda/components/loading_animation.dart';
import 'package:moda/components/proses_loading.dart';
import 'package:moda/model/karyawan_model.dart';
import 'package:moda/screen/pemilik_loket/karyawan/karyawan_add.dart';
import 'package:moda/service/api_karyawan_service.dart';

class Karyawan extends StatefulWidget {
  const Karyawan({super.key});

  @override
  State<Karyawan> createState() => _KaryawanState();
}

class _KaryawanState extends State<Karyawan> {
  final ApiKaryawanService apiKaryawanService = ApiKaryawanService();
  final List<KaryawanModel> _karyawans = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _isInitialLoading = true;
  bool _allDataLoaded = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchKaryawans(_currentPage);
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

  Future<void> _fetchKaryawans(int page) async {
    if (page == 1) {
      setState(() {
        _isInitialLoading = true;
      });
    }

    try {
      final karyawanResponse = await apiKaryawanService.fetchKaryawans(page);

      setState(() {
        if (page == 1) {
          _karyawans.clear();
        }
        _karyawans.addAll(karyawanResponse.data);
        _currentPage = karyawanResponse.currentPage + 1;
        _isLoadingMore = false;
        _isInitialLoading = false;
        _allDataLoaded =
            karyawanResponse.currentPage >= karyawanResponse.lastPage;
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
      _fetchKaryawans(_currentPage);
    }
  }

  Future<void> refreshKaryawans() async {
    _karyawans.clear();
    _currentPage = 1;
    _allDataLoaded = false;
    await _fetchKaryawans(_currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.abus,
      appBar: AppBar(
        title: Text(
          "Karyawan",
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
                  builder: (context) => KaryawanAdd(refreshKaryawans),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshKaryawans,
        color: AppColor.accentColor,
        backgroundColor: AppColor.putih,
        child: _isInitialLoading
            ? const Center(child: ProsesLoading())
            : _karyawans.isEmpty
                ? _buildEmptyState()
                : _buildKaryawanList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage('assets/karyawan.png'),
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 24),
          Text(
            'Belum ada karyawan',
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
                  builder: (context) => KaryawanAdd(refreshKaryawans),
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
              'Tambah Karyawan',
              style: GoogleFonts.fredoka(color: AppColor.putih),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKaryawanList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _karyawans.length + (_allDataLoaded ? 0 : 1),
      itemBuilder: (context, index) {
        if (index < _karyawans.length) {
          final karyawan = _karyawans[index];
          return _buildKaryawanCard(karyawan, index);
        } else {
          return _buildLoadMoreIndicator();
        }
      },
    );
  }

  Widget _buildKaryawanCard(KaryawanModel karyawan, int index) {
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
            karyawan.name!,
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
                '${karyawan.noHp}',
                style: GoogleFonts.fredoka(
                  color: AppColor.black.withValues(),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          trailing: _buildPopupMenu(karyawan),
        ),
      ),
    );
  }

  Widget _buildPopupMenu(KaryawanModel karyawan) {
    return PopupMenuButton<String>(
      color: AppColor.putih,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onSelected: (value) {
        if (value == 'edit') {
          // Navigator.push(...)
        } else if (value == 'delete') {
          // _showDeleteConfirmationDialog(karyawan.id!)
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
