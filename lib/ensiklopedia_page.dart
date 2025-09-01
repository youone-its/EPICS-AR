import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ensiklopedia_detail_page.dart';

class EnsiklopediaPage extends StatefulWidget {
  const EnsiklopediaPage({super.key});

  @override
  State<EnsiklopediaPage> createState() => _EnsiklopediaPageState();
}

class _EnsiklopediaPageState extends State<EnsiklopediaPage> {
  List<dynamic> allData = [];
  List<dynamic> filteredData = [];
  String selectedCategory = "Semua";
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadJson();
  }

  Future<void> _loadJson() async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString("assets/ensiklopedia.json");
    List<dynamic> jsonData = json.decode(jsonString);

    setState(() {
      allData = jsonData;
      filteredData = jsonData;
    });
  }

  void _filterData() {
    String query = searchController.text.toLowerCase();

    setState(() {
      filteredData = allData.where((item) {
        final title = item["title"].toString().toLowerCase();
        final desc = item["desc"].toString().toLowerCase();
        final category = item["category"].toString();

        bool matchSearch = title.contains(query) || desc.contains(query);
        bool matchCategory =
            selectedCategory == "Semua" || category == selectedCategory;

        return matchSearch && matchCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFDD44),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Header ===
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset("assets/left.svg", width: 28),
                  ),
                  const SizedBox(width: 12),
                  SvgPicture.asset("assets/ensiklopedi.svg", height: 40),
                ],
              ),
              const SizedBox(height: 20),

              // === Search bar ===
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) => _filterData(),
                        decoration: InputDecoration(
                          hintText: "Cari sesuatu...",
                          hintStyle: GoogleFonts.dynaPuff(
                            textStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // === Categories ===
              SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildChip("Semua"),
                    _buildChip("Geografi"),
                    _buildChip("Sains"),
                    _buildChip("Biologi"),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // === List ===
              Expanded(
                child: filteredData.isEmpty
                    ? Center(
                        child: Text(
                          "Tidak ada data",
                          style: GoogleFonts.dynaPuff(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          final item = filteredData[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EnsiklopediaDetailPage(
                                    title: item["title"],
                                    imagePath: item["image"],
                                    content: item["content"],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item["title"],
                                    style: GoogleFonts.dynaPuff(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item["desc"],
                                    style: GoogleFonts.dynaPuff(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    bool isSelected = label == selectedCategory;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label;
        });
        _filterData();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF95ABFE) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF95ABFE) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.dynaPuff(
            textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
