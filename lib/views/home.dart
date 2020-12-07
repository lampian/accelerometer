import 'package:accelerometer/controllers/home_controller.dart';
import 'package:accelerometer/views/app_slider.dart';
import 'package:accelerometer/views/home_drawer.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Home extends GetWidget<HomeController> {
  Widget build(BuildContext context) {
    controller.initController();
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBar(
            title: Text('title'),
            actions: [],
          ),
          drawer: HomeDrawer(),
          body: handleOrientation(),
        );
      },
    );
  }

  Widget handleOrientation() {
    if (Get.context.isLargeTablet) {
      return getPortrait();
    } else if (Get.context.isTablet) {
      return getPortrait();
    } else {
      if (Get.context.isLandscape) {
        return getLandscape();
      } else {
        return getPortrait();
      }
    }
  }

  Widget getLandscape() {
    return Row(
      children: [
        Expanded(
          flex: 8,
          child: Container(
            color: Colors.orange[200],
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.blue[200],
                    child: xGroup(),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.green[200],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.amber[200],
                  ),
                ),
              ],
            ),
          ),
        ),

        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
            child: Container(
              color: Colors.indigo[200],
              child: AppSlider(
                vertical: true,
                callBack: controller.sliderCallBack,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.lime,
            child: landscapeControlGroup(),
          ),
        ), //,
      ],
    );
  }

  Widget getPortrait() {
    return Column(
      children: [
        //SizedBox(height: 3),
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.blue[200],
            child: xGroup(),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.green[200],
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.amber[200],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: Container(
              color: Colors.indigo[200],
              child: AppSlider(
                vertical: false,
                callBack: controller.sliderCallBack,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.lime,
            child: portraitControlGroup(),
          ),
        ), //,
      ],
    );
  }

  Widget xGroup() {
    return GetBuilder<HomeController>(builder: (value) {
      return appChart(0);
    });
  }

  Widget portraitControlGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        cmndButton(),
        trigStartButton(),
        trigStopButton(),
        captureButton(),
      ],
    );
  }

  Widget landscapeControlGroup() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        cmndButton(),
        trigStartButton(),
        trigStopButton(),
        captureButton(),
      ],
    );
  }

  // TimeSeriesChart barChart(int index) {
  //   TimeSeriesChart aTSC = TimeSeriesChart(
  LineChart appChart(int index) {
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

  Widget cmndButton() {
    return ElevatedButton(
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
    );
  }

  Widget trigStartButton() {
    return ElevatedButton.icon(
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
    );
  }

  Widget trigStopButton() {
    return ElevatedButton.icon(
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
    );
  }

  Widget captureButton() {
    return ElevatedButton(
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
    );
  }
}
