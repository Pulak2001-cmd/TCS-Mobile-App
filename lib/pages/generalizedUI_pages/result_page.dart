import 'package:flutter/material.dart';
import 'package:flutter_login_ui/models/potato_data_model.dart';
import 'package:flutter_login_ui/widgets/generalizedUI_results_charts/total_sugar/total_sugar_trend_with_T_line_chart_widget.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../widgets/generalizedUI_results_charts/pH/pH_trend_at_T_and_RH_line_chart_widget.dart';
import '../../widgets/generalizedUI_results_charts/pH/pH_trend_with_T_line_chart_widget.dart';
import '../../widgets/generalizedUI_results_charts/reducing_sugar/rs_trend_T_line_chart_widget.dart';
import '../../widgets/generalizedUI_results_charts/reducing_sugar/rs_trend_varitety_line_chart_widget.dart';
import '../../widgets/generalizedUI_results_charts/starch/starch_trend_at_T_and_RH_line_chart_widget.dart';
import '../../widgets/generalizedUI_results_charts/starch/starch_trend_with_T_line_chart_widget.dart';
import '../../widgets/generalizedUI_results_charts/total_sugar/total_sugar_trend_at_T_and_RH_line_chart_widget.dart';

class ResultPage extends StatelessWidget {

  dynamic result;
  String selectedParameter;
  double? T;
  double? rh;
  PotatoData? selectedVariety;
  double? currentRS;

  //STEP1: selection of intents {0: Prediction of RS after a given time, 1: RS trend at a particular T for a given variety}
  bool isSelected0 , isSelected1, isSelected2;

  ResultPage({Key? key,required this.selectedParameter, this.result, this.isSelected0 = false, this.isSelected1= false, this.isSelected2= false, this.T, this.rh, this.selectedVariety, this.currentRS}) : super(key: key);

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
        appBar: AppBar(
          title: Text(selectedParameter,style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(child: showResults(selectedParameter)),

      ),
    );
  }

  Widget showResults(String selectedParameter) {
    if(selectedParameter == 'Weight')
      return buildWeightResults();
    else if (selectedParameter == 'Transpiration')
      return buildTranspirationResults();
    else if (selectedParameter == 'Reducing Sugar')
      return buildReducingSugarResults();
    else if (selectedParameter == 'pH')
      return buildPhResults();
    else if (selectedParameter == 'Total sugar')
      return buildTotalSugarResults();
    // else if (selectedParameter == 'Chips color')
    //   return buildChipsColorResults();
    else if (selectedParameter == 'Starch')
      return buildStarchResults();
    else if (selectedParameter == 'Sprout Status')
      return buildSproutStatusResults();
    else
      return buildAppearanceOfPotatoResults();
  }

  Widget buildWeightResults(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        isSelected0 ? buildResultCard('Predicted RS value over the given storage time:', '${result?.toStringAsFixed(2)} %w/FW', SizedBox()) : SizedBox(),
        isSelected1 ? buildResultCard('RS trend at a particular T for a given variety:', '${result?.toStringAsFixed(2)} %w/FW', SizedBox()) : SizedBox(),
        isSelected2 ? buildResultCard('RS trend for a given variety:', '${result?.toStringAsFixed(2)} %w/FW', SizedBox()) : SizedBox(),
        ElevatedButton(
          onPressed: (){},
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                Icon(Icons.download),
                Text('Download results'),
              ]
          ),
        ),
        SizedBox(height: 16,),
      ],
    );
  }

  Widget buildTranspirationResults(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        isSelected0 ? buildResultCard('Effect of Temperature and Relative Humidity:', '', Image.asset('assets/images/foo.png')) : SizedBox(),
        isSelected1 ? buildResultCard('Transpiration rate at Temperature $T °C and Relative Humidity $rh %', '${result?.toStringAsFixed(2)} g/kg/day', SizedBox()) : SizedBox(),
        ElevatedButton(
          onPressed: (){},
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                Icon(Icons.download),
                Text('Download results'),
              ]
          ),
        ),
        SizedBox(height: 16,),
      ],
    );
  }

  Widget buildReducingSugarResults(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        isSelected0 ? buildResultCard('Predicted RS value over the given storage time:', '${result?.toStringAsFixed(2)} %w/FW', SizedBox()): SizedBox(),
        isSelected1 ? buildResultCard('RS trend at a particular T for a given variety:', '', Container(
          // clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.fromLTRB(2,2,16,2),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          width: double.infinity,
          height: 250,
          child: Column(
            children: [
              Expanded(child: RSTrendTLineChartWidget(selectedVariety: selectedVariety!, currentRS: currentRS ?? -1, T: T ?? -1,)),
              Text(
                '(time in days)',
                style:TextStyle(
                  color: Color(0xff72719b),
                ) ,
              ),
            ],
          ),

        )) : SizedBox(),
        isSelected2 ? buildResultCard('RS trend for a given variety:', '', Container(
          // clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.fromLTRB(2,2,16,2),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          width: double.infinity,
          height: 300,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GradientText(
                      '- 2 °C',
                      colors: [
                        Colors.blueGrey[200]!,
                        Colors.blueGrey[500]!,
                        ],
                    ),
                    GradientText(
                      '- 4 °C',
                      colors: [
                        Colors.blue[200]!,
                        Colors.blue[500]!,
                      ],
                    ),
                    GradientText(
                      '- 6 °C',
                      colors: [
                        Colors.purple[200]!,
                        Colors.purple[500]!,
                      ],
                    ),
                    GradientText(
                      '- 8 °C',
                      colors: [
                        Colors.green[200]!,
                        Colors.green[500]!,
                      ],
                    ),
                    GradientText(
                      '- 10 °C',
                      colors: [
                        Colors.red[200]!,
                        Colors.red[500]!,
                      ],
                    ),
                    GradientText(
                      '- 12 °C',
                      colors: [
                        Colors.yellow[200]!,
                        Colors.yellow[500]!,
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24,),
              Expanded(child: RSTrendVarietyLineChartWidget(selectedVariety: selectedVariety!, currentRS: currentRS ?? -1, T: T ?? -1,)),
              Text(
                '(time in days)',
                style:TextStyle(
                  color: Color(0xff72719b),
                ) ,
              ),
            ],
          ),

        )) : SizedBox(),
        ElevatedButton(
          onPressed: (){},
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                Icon(Icons.download),
                Text('Download results'),
              ]
          ),
        ),
        SizedBox(height: 16,),
      ],
    );
  }

  Widget buildPhResults(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        isSelected0 ? buildResultCard('Effect of T on pH', '', Container(
          // clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.fromLTRB(2,2,2,2),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          width: double.infinity,
          height: 300,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GradientText(
                      '5 °C',
                      colors: [
                        Colors.blueGrey[200]!,
                        Colors.blueGrey[500]!,
                      ],
                    ),
                    GradientText(
                      '10 °C',
                      colors: [
                        Colors.blue[200]!,
                        Colors.blue[500]!,
                      ],
                    ),
                    GradientText(
                      '15 °C',
                      colors: [
                        Colors.purple[200]!,
                        Colors.purple[500]!,
                      ],
                    ),
                    GradientText(
                      '20 °C',
                      colors: [
                        Colors.green[200]!,
                        Colors.green[500]!,
                      ],
                    ),
                    GradientText(
                      '25 °C',
                      colors: [
                        Colors.red[200]!,
                        Colors.red[500]!,
                      ],
                    ),
                    GradientText(
                      '30 °C',
                      colors: [
                        Colors.yellow[200]!,
                        Colors.yellow[500]!,
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24,),
              Expanded(child: Padding(
                padding: const EdgeInsets.fromLTRB(0,0,14,0),
                child: PhTrendTLineChartWidget(selectedVariety: selectedVariety!, currentRS: currentRS ?? -1, T: T ?? -1,),
              )),
              Text(
                '(time in days)',
                style:TextStyle(
                  color: Color(0xff72719b),
                ) ,
              ),
            ],
          ),

        )) : SizedBox(),
        isSelected1 ? buildResultCard('Change in pH at a particular T and RH', '', Container(
          // clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.fromLTRB(2,2,16,2),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          width: double.infinity,
          height: 250,
          child: Column(
            children: [
              Expanded(child: PhTrendAtTAndRHLineChartWidget(selectedVariety: selectedVariety!, currentRS: currentRS ?? -1, T: T ?? -1,)),
              Text(
                '(time in days)',
                style:TextStyle(
                  color: Color(0xff72719b),
                ) ,
              ),
            ],
          ),

        )) : SizedBox(),
        ElevatedButton(
          onPressed: (){},
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                Icon(Icons.download),
                Text('Download results'),
              ]
          ),
        ),
        SizedBox(height: 16,),
      ],
    );
  }

  Widget buildTotalSugarResults(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        isSelected0 ? buildResultCard('Effect of T on total sugar', '', Container(
          // clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.fromLTRB(2,2,2,2),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          width: double.infinity,
          height: 300,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GradientText(
                      '5 °C',
                      colors: [
                        Colors.blueGrey[200]!,
                        Colors.blueGrey[500]!,
                      ],
                    ),
                    GradientText(
                      '10 °C',
                      colors: [
                        Colors.blue[200]!,
                        Colors.blue[500]!,
                      ],
                    ),
                    GradientText(
                      '15 °C',
                      colors: [
                        Colors.purple[200]!,
                        Colors.purple[500]!,
                      ],
                    ),
                    GradientText(
                      '20 °C',
                      colors: [
                        Colors.green[200]!,
                        Colors.green[500]!,
                      ],
                    ),
                    GradientText(
                      '25 °C',
                      colors: [
                        Colors.red[200]!,
                        Colors.red[500]!,
                      ],
                    ),
                    GradientText(
                      '30 °C',
                      colors: [
                        Colors.yellow[200]!,
                        Colors.yellow[500]!,
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24,),
              Expanded(child: Padding(
                padding: const EdgeInsets.fromLTRB(0,0,14,0),
                child: TotalSugarTrendTLineChartWidget(selectedVariety: selectedVariety!, currentRS: currentRS ?? -1, T: T ?? -1,),
              )),
              Text(
                '(time in days)',
                style:TextStyle(
                  color: Color(0xff72719b),
                ) ,
              ),
            ],
          ),

        )) : SizedBox(),
        isSelected1 ? buildResultCard('Change in total sugar at a particular T and RH', '', Container(
          // clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.fromLTRB(2,2,16,2),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          width: double.infinity,
          height: 250,
          child: Column(
            children: [
              Expanded(child: TotalSugarTrendAtTAndRHLineChartWidget(selectedVariety: selectedVariety!, currentRS: currentRS ?? -1, T: T ?? -1,)),
              Text(
                '(time in days)',
                style:TextStyle(
                  color: Color(0xff72719b),
                ) ,
              ),
            ],
          ),

        )) : SizedBox(),
        ElevatedButton(
          onPressed: (){},
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                Icon(Icons.download),
                Text('Download results'),
              ]
          ),
        ),
        SizedBox(height: 16,),
      ],
    );
  }

  Widget buildStarchResults(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        isSelected0 ? buildResultCard('Effect of T on Starch', '', Container(
          // clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.fromLTRB(2,2,2,2),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          width: double.infinity,
          height: 300,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GradientText(
                      '5 °C',
                      colors: [
                        Colors.blueGrey[200]!,
                        Colors.blueGrey[500]!,
                      ],
                    ),
                    GradientText(
                      '10 °C',
                      colors: [
                        Colors.blue[200]!,
                        Colors.blue[500]!,
                      ],
                    ),
                    GradientText(
                      '15 °C',
                      colors: [
                        Colors.purple[200]!,
                        Colors.purple[500]!,
                      ],
                    ),
                    GradientText(
                      '20 °C',
                      colors: [
                        Colors.green[200]!,
                        Colors.green[500]!,
                      ],
                    ),
                    GradientText(
                      '25 °C',
                      colors: [
                        Colors.red[200]!,
                        Colors.red[500]!,
                      ],
                    ),
                    GradientText(
                      '30 °C',
                      colors: [
                        Colors.yellow[200]!,
                        Colors.yellow[500]!,
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24,),
              Expanded(child: Padding(
                padding: const EdgeInsets.fromLTRB(0,0,14,0),
                child: StarchTrendTLineChartWidget(selectedVariety: selectedVariety!, currentRS: currentRS ?? -1, T: T ?? -1,),
              )),
              Text(
                '(time in days)',
                style:TextStyle(
                  color: Color(0xff72719b),
                ) ,
              ),
            ],
          ),

        )) : SizedBox(),
        isSelected1 ? buildResultCard('Change in starch at a particular T and RH', '', Container(
          // clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.fromLTRB(2,2,16,2),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          width: double.infinity,
          height: 250,
          child: Column(
            children: [
              Expanded(child: StarchTrendAtTAndRHLineChartWidget(selectedVariety: selectedVariety!, currentRS: currentRS ?? -1, T: T ?? -1,)),
              Text(
                '(time in days)',
                style:TextStyle(
                  color: Color(0xff72719b),
                ) ,
              ),
            ],
          ),

        )) : SizedBox(),
        ElevatedButton(
          onPressed: (){},
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                Icon(Icons.download),
                Text('Download results'),
              ]
          ),
        ),
        SizedBox(height: 16,),
      ],
    );
  }

  Widget buildSproutStatusResults(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        result ? buildResultCard('Yes, the image is sprouted', '', SizedBox()): buildResultCard('No, the image is not sprouted', '', SizedBox()),
        ElevatedButton(
          onPressed: (){},
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                Icon(Icons.download),
                Text('Download results'),
              ]
          ),
        ),
        SizedBox(height: 16,),
      ],
    );
  }

  Widget buildAppearanceOfPotatoResults(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        isSelected0 ? buildResultCard('Effect of T on pH', '', Container(
          // clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.fromLTRB(2,2,16,2),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          width: double.infinity,
          height: 300,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GradientText(
                      '5 °C',
                      colors: [
                        Colors.blueGrey[200]!,
                        Colors.blueGrey[500]!,
                      ],
                    ),
                    GradientText(
                      '10 °C',
                      colors: [
                        Colors.blue[200]!,
                        Colors.blue[500]!,
                      ],
                    ),
                    GradientText(
                      '15 °C',
                      colors: [
                        Colors.purple[200]!,
                        Colors.purple[500]!,
                      ],
                    ),
                    GradientText(
                      '20 °C',
                      colors: [
                        Colors.green[200]!,
                        Colors.green[500]!,
                      ],
                    ),
                    GradientText(
                      '25 °C',
                      colors: [
                        Colors.red[200]!,
                        Colors.red[500]!,
                      ],
                    ),
                    GradientText(
                      '30 °C',
                      colors: [
                        Colors.yellow[200]!,
                        Colors.yellow[500]!,
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24,),
              Expanded(child: PhTrendTLineChartWidget(selectedVariety: selectedVariety!, currentRS: currentRS ?? -1, T: T ?? -1,)),
              Text(
                '(time in days)',
                style:TextStyle(
                  color: Color(0xff72719b),
                ) ,
              ),
            ],
          ),

        )) : SizedBox(),
        isSelected1 ? buildResultCard('Change in pH at a particular T and RH', '', Container(
          // clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.fromLTRB(2,2,16,2),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          width: double.infinity,
          height: 250,
          child: Column(
            children: [
              Expanded(child: RSTrendTLineChartWidget(selectedVariety: selectedVariety!, currentRS: currentRS ?? -1, T: T ?? -1,)),
              Text(
                '(time in days)',
                style:TextStyle(
                  color: Color(0xff72719b),
                ) ,
              ),
            ],
          ),

        )) : SizedBox(),
        ElevatedButton(
          onPressed: (){},
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                Icon(Icons.download),
                Text('Download results'),
              ]
          ),
        ),
        SizedBox(height: 16,),
      ],
    );
  }



  //Result page
  Widget buildResultCard(String text, String result, Widget showWidget) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      color: Colors.black12,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text,
            style: TextStyle(
                color: Colors.white70,
                fontSize: 20
            ),),
          SizedBox(
            height: 16,
          ),
          (result == '') ? SizedBox() : Text(result,
            style: TextStyle(
                color: Colors.white,
                fontSize: 30
            ),),
          // showImage ? Container(
          //   // clipBehavior: Clip.antiAlias,
          //   padding: EdgeInsets.fromLTRB(2,2,16,2),
          //   decoration: BoxDecoration(
          //     color: Colors.transparent,
          //   ),
          //   width: double.infinity,
          //   height: 250,
          //   child: CO2ConcLineChartWidget(),
          //
          // ) : SizedBox(),
          showWidget,
        ],
      ),
    );
  }
}

