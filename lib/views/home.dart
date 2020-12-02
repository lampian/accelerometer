import 'package:accelerometer/controllers/auth_controller.dart';
import 'package:accelerometer/controllers/home_controller.dart';
import 'package:accelerometer/utils/root.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Home extends GetWidget<HomeController> {
  Widget build(BuildContext context) {
    controller.initController();
    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
        actions: [],
      ),
      drawer: menu(),
      body: getBody(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => controller.handleStopGo(),
      //   child: Icon(Icons.toggle_on),
      // ),
    );
  }

  menu() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(3.0),
        children: [
          Container(
            height: 60.0,
            child: DrawerHeader(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select action:',
                  textAlign: TextAlign.end,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.green[300],
              ),
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              margin: EdgeInsets.all(0.0),
            ),
          ),
          ListTile(
            title: Text('Toggle theme black'),
            onTap: () {
              if (Get.isDarkMode) {
                Get.changeTheme(ThemeData.light());
              } else {
                Get.changeTheme(ThemeData.dark());
              }
            },
          ),
          ListTile(
            title: Text('Sign out'),
            onTap: () {
              Get.find<AuthController>().signOut();
              Get.offAll(Root());
            },
          ),
        ],
      ),
    );
  }

  getBody() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 200,
          child: GetBuilder<HomeController>(
            builder: (value) {
              return SizedBox(
                height: 100,
                child: barChart(0),
              );
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: Obx(() => Text(controller.cmndText())),
              onPressed: () => controller.handleCmndPressed(),
              style: ElevatedButton.styleFrom(
                primary: Colors.blueGrey[600],
                elevation: 15.0,
                shadowColor: Colors.grey[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(color: Colors.grey[600]),
                ),
              ),
            ),
            ElevatedButton.icon(
              label: Obx(() => Text(controller.trigStartText())),
              icon: Icon(Icons.play_arrow),
              onPressed: () => controller.handleTrigStartPressed(),
              style: ElevatedButton.styleFrom(
                primary: Colors.blueGrey[600],
                elevation: 15.0,
                shadowColor: Colors.grey[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(color: Colors.grey[600]),
                ),
              ),
            ),
            ElevatedButton.icon(
              label: Obx(() => Text(controller.trigStopText())),
              icon: Icon(Icons.stop),
              onPressed: () => controller.handleTrigStopPressed(),
              style: ElevatedButton.styleFrom(
                primary: Colors.blueGrey[600],
                elevation: 15.0,
                shadowColor: Colors.grey[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(color: Colors.grey[600]),
                ),
              ),
            ),
            ElevatedButton(
              child: Obx(() => Text(controller.modeText())),
              onPressed: () => controller.handleModePressed(),
              style: ElevatedButton.styleFrom(
                primary: Colors.blueGrey[600],
                elevation: 15.0,
                shadowColor: Colors.grey[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(color: Colors.grey[600]),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 12,
        ),
      ],
    );
  }

  // TimeSeriesChart barChart(int index) {
  //   TimeSeriesChart aTSC = TimeSeriesChart(
  LineChart barChart(int index) {
    LineChart aTSC = LineChart(
      controller.getSeriesList(),
      animate: false,
      behaviors: [
        // ChartTitle(
        //   'r1000',
        //   titleStyleSpec: TextStyleSpec(color: Color.white),
        // ),
        ChartTitle(
          'test', //controller.chs[index].toString(),
          behaviorPosition: BehaviorPosition.start,
          titleStyleSpec: TextStyleSpec(color: Color.white),
        ),
        //SelectNearest(),
        //DomainHighlighter(),
        //PanAndZoomBehavior(), //not working well, cannot zoom right
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
      // domainAxis: NumericAxisSpec(
      //   viewport: NumericExtents(
      //     controller.dmnViewPortX1,
      //     controller.dmnViewPortX2,
      //   ),
      // ),
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
        viewport: NumericExtents(-6, 6),
        tickProviderSpec: StaticNumericTickProviderSpec(
          [
            TickSpec(-10),
            TickSpec(-8),
            TickSpec(-6),
            TickSpec(-4),
            TickSpec(-2),
            TickSpec(0),
            TickSpec(2),
            TickSpec(4),
            TickSpec(6),
            TickSpec(8),
            TickSpec(10),
          ],
        ),
      ),
    );
    return aTSC;
  }
}
