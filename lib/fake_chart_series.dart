class FakeChartSeries {
  Map<DateTime, double> createLineData(double factor) {
    Map<DateTime, double> data = {};

    for (int c = 50; c > 0; c--) {
      data[DateTime.now().subtract(Duration(minutes: c))] =
          c.toDouble() * factor;
    }

    return data;
  }


  Map<DateTime, double> createLine2() {
    Map<DateTime, double> data = {};
    data[DateTime.now().subtract(Duration(minutes: 40))] = 13.0;
    data[DateTime.now().subtract(Duration(minutes: 30))] = 24.0;
    data[DateTime.now().subtract(Duration(minutes: 22))] = 39.0;
    data[DateTime.now().subtract(Duration(minutes: 20))] = 29.0;
    data[DateTime.now().subtract(Duration(minutes: 15))] = 27.0;
    data[DateTime.now().subtract(Duration(minutes: 12))] = 9.0;
    data[DateTime.now().subtract(Duration(minutes: 5))] = 35.0;
    return data;
  }

  Map<DateTime, double> createLine2_2() {
    Map<DateTime, double> data = {};
    data[DateTime.now().subtract(Duration(minutes: 40))] = 30.0;
    data[DateTime.now().subtract(Duration(minutes: 30))] = 48.0;
    data[DateTime.now().subtract(Duration(minutes: 22))] = 67.0;
    data[DateTime.now().subtract(Duration(minutes: 20))] = 99.0;
    data[DateTime.now().subtract(Duration(minutes: 15))] = 23.0;
    data[DateTime.now().subtract(Duration(minutes: 12))] = 47.0;
    data[DateTime.now().subtract(Duration(minutes: 5))] = 10.0;
    return data;
  }

}