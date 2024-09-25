import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moda/components/app_color.dart';
import 'package:moda/components/loading_animation.dart';
import 'package:moda/components/proses_loading.dart';
import 'package:moda/model/angkutan_model.dart';
import 'package:moda/screen/pemilik_loket/angkutan/angkutan_add.dart';
import 'package:moda/service/api_angkutan_service.dart';

class Angkutan extends StatefulWidget {
  const Angkutan({super.key});

  @override
  State<Angkutan> createState() => _AngkutanState();
}

class _AngkutanState extends State<Angkutan> {
  final ApiAngkutanService apiAngkutanService = ApiAngkutanService();
  final List<AngkutanModel> _angkutans = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _isInitialLoading = true;
  bool _allDataLoaded = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchAngkutans(_currentPage);
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

  Future<void> _fetchAngkutans(int page) async {
    if (page == 1) {
      setState(() {
        _isInitialLoading = true;
      });
    }

    try {
      final angkutanResponse = await apiAngkutanService.fetchAngkutans(page);

      setState(() {
        if (page == 1) {
          _angkutans.clear();
        }
        _angkutans.addAll(angkutanResponse.data);
        _currentPage = angkutanResponse.currentPage + 1;
        _isLoadingMore = false;
        _isInitialLoading = false;
        _allDataLoaded =
            angkutanResponse.currentPage >= angkutanResponse.lastPage;
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
      _fetchAngkutans(_currentPage);
    }
  }

  Future<void> refreshAngkutans() async {
    _angkutans.clear();
    _currentPage = 1;
    _allDataLoaded = false;
    await _fetchAngkutans(_currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.abus,
      appBar: AppBar(
        title: Text(
          "Angkutan",
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
                  builder: (context) => AngkutanAdd(refreshAngkutans),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshAngkutans,
        color: AppColor.accentColor,
        backgroundColor: AppColor.putih,
        child: _isInitialLoading
            ? const Center(child: ProsesLoading())
            : _angkutans.isEmpty
                ? _buildEmptyState()
                : _buildAngkutanList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage('assets/angkutan.png'),
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 24),
          Text(
            'Belum ada angkutan',
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
                  builder: (context) => AngkutanAdd(refreshAngkutans),
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
              'Tambah Angkutan',
              style: GoogleFonts.fredoka(color: AppColor.putih),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAngkutanList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _angkutans.length + (_allDataLoaded ? 0 : 1),
      itemBuilder: (context, index) {
        if (index < _angkutans.length) {
          final angkutan = _angkutans[index];
          return _buildAngkutanCard(angkutan, index);
        } else {
          return _buildLoadMoreIndicator();
        }
      },
    );
  }

  Widget _buildAngkutanCard(AngkutanModel angkutan, int index) {
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
            angkutan.nama!,
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
                'Plat: ${angkutan.plat}',
                style: GoogleFonts.fredoka(
                  color: AppColor.black.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              Text(
                'Kapasitas: ${angkutan.kapasitas}',
                style: GoogleFonts.fredoka(
                  color: AppColor.black.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          trailing: _buildPopupMenu(angkutan),
        ),
      ),
    );
  }

  Widget _buildPopupMenu(AngkutanModel angkutan) {
    return PopupMenuButton<String>(
      color: AppColor.putih,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onSelected: (value) {
        if (value == 'edit') {
          // Navigator.push(...)
        } else if (value == 'delete') {
          // _showDeleteConfirmationDialog(angkutan.id!)
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
