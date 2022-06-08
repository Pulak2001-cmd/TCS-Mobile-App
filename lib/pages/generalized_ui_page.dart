import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/generalizedUI_tabBar_views/arable_view.dart';
import 'package:flutter_login_ui/pages/generalizedUI_tabBar_views/dairy_view.dart';
import 'package:flutter_login_ui/pages/generalizedUI_tabBar_views/fruits_view.dart';
import 'package:flutter_login_ui/pages/generalizedUI_tabBar_views/meat_view.dart';
import 'package:flutter_login_ui/pages/generalizedUI_tabBar_views/vegetables_view.dart';
import 'package:hexcolor/hexcolor.dart';

import '../widgets/drawer_widget.dart';
class GeneralizedUIPage extends StatefulWidget {
  const GeneralizedUIPage({Key? key}) : super(key: key);

  @override
  State<GeneralizedUIPage> createState() => _GeneralizedUIPageState();
}

class _GeneralizedUIPageState extends State<GeneralizedUIPage> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  int _selectedIndex = 0;



  @override
  void initState(){
    super.initState();

    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose(){
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: <Color>[
            Theme.of(context).primaryColor,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text("Generalized UI",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
        ),
        drawer: SideDrawer(),
        body: Container(
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 16,horizontal: 0),
          width: double.infinity,
          child: SafeArea(
            child: DefaultTabController(
              length: 5,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16,0,0,16),
                      child: Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                      ),
                    ),
                  ),
                  Theme(
                    data: ThemeData().copyWith(
                      splashColor: HexColor('#00FFFFFF'),
                    ),
                    child: TabBar(
                      labelPadding: EdgeInsets.symmetric(horizontal: 8),
                      controller: _tabController,
                      labelColor: Colors.white,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                      unselectedLabelColor: Colors.white24,
                      unselectedLabelStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                      indicatorColor: HexColor('#00FFFFFF'),
                      isScrollable: true,
                        tabs: [
                          buildTab('Dairy',0),
                          buildTab('Meat',1),
                          buildTab('Fruits',2),
                          buildTab('Vegetables',3),
                          buildTab('Arable',4),
                        ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                        children: [
                          DairyView(),
                          MeatView(),
                          FruitsView(),
                          VegetablesView(),
                          ArableView(),
                        ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTab(String label, int index) {
    return Tab(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: _selectedIndex == index ? Colors.white10 : Colors.black12,
          ),
          child: Text(label),
      ),
    );
  }
}
