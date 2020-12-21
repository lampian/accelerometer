// @dart=2.9
import 'package:accelerometer/models/sensor_model.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class SensorChart extends StatelessWidget {
  //SensorChart({Key key}) : super(key: key) {}
  SensorChart({
    @required this.data,
    @required this.x1,
    @required this.x2,
    @required this.title,
  });
  final List<Series<SensorModel, int>> data;
  int x1 = 0;
  int x2 = 1;
  String title = '';
  @override
  Widget build(BuildContext context) {
    return chart();
  }

  LineChart chart() {
    LineChart aTSC = LineChart(
      data ?? [], //homeController.getSeriesList(),
      animate: false,
      behaviors: [
        // ChartTitle(
        //   'r1000',
        //   titleStyleSpec: TextStyleSpec(color: Color.white),
        // ),
        ChartTitle(
          title ?? '', //controller.chs[index].toString(),
          behaviorPosition: BehaviorPosition.start,
          titleStyleSpec: TextStyleSpec(color: Color.white),
        ),
        //SelectNearest(),
        //DomainHighlighter(),
        SlidingViewport(),
        PanAndZoomBehavior(), //not working well, cannot zoom right
      ],
      // Optionally pass in a [DateTimeFactory] used by the chart.
      // The factory should create the same type of [DateTime] as
      // the data provided. If none specified, the default creates
      // local date time.
      //dateTimeFactory: LocalDateTimeFactory(),

      // Customizes the date tick formatter. It will print the
      // day of month as the default format, but include the
      // month and year if it transitions to a new month.
      // minute, hour, day, month, and year are all provided
      // by default and you can override them following this
      // pattern.
      // domainAxis: DateTimeAxisSpec(
      //   tickFormatterSpec: AutoDateTimeTickFormatterSpec(
      //     day: TimeFormatterSpec(format: 'd', transitionFormat: 'MM/dd/yyyy'),
      //   ),
      // ),
      domainAxis: NumericAxisSpec(
        viewport: NumericExtents(
          x1 ?? 1, //homeController.dmnViewPortX1,
          x2 ?? 40, //homeController.dmnViewPortX2,
        ),
      ),
      primaryMeasureAxis: NumericAxisSpec(
        renderSpec: GridlineRendererSpec(
          // Tick and Label styling here.
          labelStyle: TextStyleSpec(
              fontSize: 12, // size in Pts.
              color: MaterialPalette.white),
          // Change the line colors to match text color.
          lineStyle: LineStyleSpec(
            color: MaterialPalette.black,
            thickness: 1,
          ),
        ),
        // viewport: NumericExtents(-10, 10),
        // tickProviderSpec: StaticNumericTickProviderSpec(
        //   [
        //     TickSpec(-10),
        //     TickSpec(-8),
        //     TickSpec(-6),
        //     TickSpec(-4),
        //     TickSpec(-2),
        //     TickSpec(0),
        //     TickSpec(2),
        //     TickSpec(4),
        //     TickSpec(6),
        //     TickSpec(8),
        //     TickSpec(10),
        //   ],
        // ),
      ),
    );
    return aTSC;
  }
}
