import 'package:flutter/cupertino.dart';

class HourlyForcastItem extends StatelessWidget {
  const HourlyForcastItem({
    super.key,
    required this.time,
    required this.icon,
    required this.temperature,
  }
  );

  final String time;
   final IconData icon;
  final String temperature;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      
      child: Container(      
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
        ),
        child:  Center(
          child: Column(
            children: [
               Text(
                time,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Icon(
                  icon,
                  size: 32,
                  ),
                  const SizedBox(
                  height: 16,
                ),
                Text(temperature),
            ],
          ),
        ),
      ),
    );
  }
}
