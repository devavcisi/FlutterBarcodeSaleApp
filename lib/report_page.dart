import 'package:easycoprombflutter/BarChartModel.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {


  final List<BarChartModel> data = [
    BarChartModel(
      year: "2015",
      financial: 10,
      color: charts.ColorUtil.fromDartColor(Colors.red),
    ),
    BarChartModel(
      year: "2019",
      financial: 15,
      color: charts.ColorUtil.fromDartColor(Colors.pink),
    ),
    BarChartModel(
      year: "2020",
      financial: 12,
      color: charts.ColorUtil.fromDartColor(Colors.purple),
    ),
  ];

  @override
  Widget build(BuildContext context) {

    List<charts.Series<BarChartModel, String>> series = [
      charts.Series(
        id: "financial",
        data: data,
        domainFn: (BarChartModel series, _) => series.year,
        measureFn: (BarChartModel series, _) => series.financial,
        colorFn: (BarChartModel series, _) => series.color,
      ),
    ];

    return SafeArea(
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 50,),
                Container(
                  width: 300,
                  height: 100,
                  child: charts.BarChart(
                    series,
                    animate: true,
                  ),
                ),
                const SizedBox(height: 20,),
                DataTable(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  dataRowColor: MaterialStateProperty.all(Colors.white),
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('DEALER')),
                    DataColumn(label: Text('CODE')),
                  ],
                  rows: const <DataRow>[
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('123456')),
                        DataCell(Text('123456')),
                        DataCell(Text('123456')),
                      ],
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }


}
