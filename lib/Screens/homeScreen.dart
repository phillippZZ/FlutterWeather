import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_weather/provider/weatherProvider.dart';
import 'package:flutter_weather/widgets/WeatherInfoHeader.dart';
import 'package:flutter_weather/widgets/mainWeatherDetail.dart';
import 'package:flutter_weather/widgets/mainWeatherInfo.dart';
import 'package:flutter_weather/widgets/sevenDayForecast.dart';
import 'package:flutter_weather/widgets/twentyFourHourForecast.dart';

class WeatherWidget extends StatefulWidget {
  final double width;
  final double height;

  const WeatherWidget({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  @override
  void initState() {
    super.initState();
    // Request weather data when widget initializes
    Future.microtask(() => 
      Provider.of<WeatherProvider>(context, listen: false)
          .getWeatherData(context)
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherProvider(),
      child: Builder(
        builder: (context) {
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Theme(
                data: ThemeData(
                  appBarTheme: const AppBarTheme(
                    backgroundColor: Colors.white,
                    iconTheme: IconThemeData(color: Colors.blue),
                    elevation: 0,
                  ),
                  scaffoldBackgroundColor: Colors.white,
                  primaryColor: Colors.blue,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
                ),
                child: Scaffold(
                  body: Consumer<WeatherProvider>(
                    builder: (context, weatherProv, _) {
                      if (weatherProv.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (weatherProv.isRequestError) {
                        return const Center(
                          child: Text('Unable to load weather data'),
                        );
                      }

                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          size: Size(widget.width, widget.height),
                          padding: EdgeInsets.zero,
                        ),
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(12.0),
                          children: const [
                            WeatherInfoHeader(),
                            SizedBox(height: 16.0),
                            MainWeatherInfo(),
                            SizedBox(height: 16.0),
                            MainWeatherDetail(),
                            SizedBox(height: 24.0),
                            TwentyFourHourForecast(),
                            SizedBox(height: 18.0),
                            SevenDayForecast(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
