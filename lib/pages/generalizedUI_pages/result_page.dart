import 'package:flutter/material.dart';
import 'package:flutter_login_ui/models/potato_data_model.dart';
import 'package:flutter_login_ui/pages/realtime_monitoring_screens/line_chart_widgets/variation_in_physical_parameters/co2_conc_line_chart.dart';
import 'package:flutter_login_ui/pages/widgets/generalizedUI_results_charts/rs_trend_T_line_chart_widget.dart';
import 'package:flutter_login_ui/pages/widgets/generalizedUI_results_charts/rs_trend_varitety_line_chart_widget.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class ResultPage extends StatelessWidget {

  double? result;
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
    else
      return buildReducingSugarResults();
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

