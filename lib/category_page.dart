import 'package:flipkart_category_section_ui_using_flutter/category_data.dart';
import 'package:flutter/material.dart';
import 'category_dto.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final double _itemHeight = 100;
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _barScrollController = ScrollController();

  List<CategoryDto> categoryData = dummyData.map((e) => CategoryDto.fromMap(e)).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'All Categories',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          // SizedBox(width: 15),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.mic),
          ),
        ],
      ),
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: categoryData.length,
                    itemBuilder: (context, index) {
                      bool isSelected = _selectedIndex == index;
                      return InkWell(
                        onTap: () {
                          _onItemSelected(index);
                          setState(() {});
                        },
                        child: _CategoriesContainer(index: index, itemHeight: _itemHeight, isSelected: isSelected, selectedIndex: _selectedIndex, categoryData: categoryData),
                      );
                    },
                  )),
              _SubCategories(categoryData: categoryData, selectedIndex: _selectedIndex)
            ],
          ),
          _ScrollBarWidget(barScrollController: _barScrollController, categoryData: categoryData, selectedIndex: _selectedIndex),
        ],
      ),
    );
  }

  void _onItemSelected(int newIndex) {
    setState(() {
      _selectedIndex = newIndex;
    });

    double targetPosition = MediaQuery.of(context).size.height * 0.5;

    int targetIndex = (targetPosition / _itemHeight).floor();

    newIndex = _selectedIndex - targetIndex;

    if (newIndex < 0) newIndex = 0;
    double position = newIndex * _itemHeight;
    _barScrollController.animateTo(
      _scrollController.offset,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
    _barScrollController.animateTo(_scrollController.offset, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
    Future.delayed(const Duration(milliseconds: 400), () {
      _scrollController.animateTo(
        position,
        duration: const Duration(seconds: 1),
        curve: Curves.fastLinearToSlowEaseIn,
      );
      _barScrollController.animateTo(
        position,
        duration: const Duration(seconds: 1),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    });
  }
}

class _CategoriesContainer extends StatelessWidget {
  const _CategoriesContainer({
    required double itemHeight,
    required this.isSelected,
    required int selectedIndex,
    required this.categoryData,
    required this.index,
  })  : _itemHeight = itemHeight,
        _selectedIndex = selectedIndex;

  final int index;
  final double _itemHeight;
  final bool isSelected;
  final int _selectedIndex;
  final List<CategoryDto> categoryData;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: _itemHeight,
      decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color.fromARGB(255, 244, 239, 252),
          borderRadius: BorderRadius.only(
            bottomRight: _selectedIndex - 1 == index ? const Radius.circular(10) : const Radius.circular(0),
            topRight: _selectedIndex + 1 == index ? const Radius.circular(10) : const Radius.circular(0),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Transform.scale(
            scale: isSelected ? 1 : 0.8,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                    height: isSelected ? 60 : 50,
                    width: isSelected ? 60 : 50,
                    decoration: BoxDecoration(
                      shape: isSelected ? BoxShape.circle : BoxShape.rectangle,
                      color: isSelected ? const Color.fromARGB(255, 193, 223, 243) : null,
                    )),
                Image.network(
                  categoryData[index].imageUrl ?? '',
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          const SizedBox(),
          Center(
              child: Transform.scale(
                  scale: isSelected ? 1 : 0.8,
                  child: Text(
                    categoryData[index].name,
                    style: TextStyle(color: isSelected ? Colors.indigo : null),
                  ))),
          (!isSelected && _selectedIndex - 1 != index)
              ? const Divider(
                  thickness: 0.8,
                  indent: 10,
                  endIndent: 10,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class _SubCategories extends StatelessWidget {
  const _SubCategories({
    required this.categoryData,
    required int selectedIndex,
  }) : _selectedIndex = selectedIndex;

  final List<CategoryDto> categoryData;
  final int _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 3,
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.white,
                Colors.grey.shade50,
                Colors.blue.shade50,
                Colors.blue.shade100,
              ])),
              // color: Colors.redAccent,
              margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: Row(
                children: [
                  Text(
                    categoryData[_selectedIndex].name,
                    style: TextStyle(color: Colors.blue.shade700, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.blue.shade700,
                  ),
                  Expanded(
                    flex: 2,
                    child: Image.network(
                      height: 100,
                      scale: .2,
                      categoryData[_selectedIndex].imageUrl ?? '',
                      // fit: BoxFit.fill,
                      filterQuality: FilterQuality.high,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                  //
                  itemCount: categoryData[_selectedIndex].group.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 15, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(categoryData[_selectedIndex].group[index].name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.indigo,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: categoryData[_selectedIndex].group[index].subGroup.length,
                          shrinkWrap: true,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                          itemBuilder: (context, i) {
                            return Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: const Color.fromARGB(255, 244, 239, 252),
                                  child: Image.network(categoryData[_selectedIndex].imageUrl!),
                                ),
                                Text(
                                  categoryData[_selectedIndex].group[index].subGroup[i],
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            );
                          },
                        )
                      ],
                    );
                  }),
            )
          ],
        ));
  }
}

class _ScrollBarWidget extends StatelessWidget {
  const _ScrollBarWidget({
    required ScrollController barScrollController,
    required this.categoryData,
    required int selectedIndex,
  })  : _barScrollController = barScrollController,
        _selectedIndex = selectedIndex;

  final ScrollController _barScrollController;
  final List<CategoryDto> categoryData;
  final int _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 3,
      child: ListView.builder(
          controller: _barScrollController,
          itemCount: categoryData.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 80,
              width: 6,
              decoration: BoxDecoration(color: _selectedIndex == index ? Colors.indigo : null, borderRadius: BorderRadius.circular(20)),
            );
          }),
    );
  }
}
