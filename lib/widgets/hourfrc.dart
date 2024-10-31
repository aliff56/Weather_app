import 'package:flutter/material.dart';

class HourFrc extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperature;
  const HourFrc({super.key,
   required this.time,
   required this.icon,
    required this.temperature,});

  @override
  Widget build(BuildContext context) {
    
    return Card(
                      shadowColor: Colors.grey.shade800.withOpacity(0.5),
                      color: const Color(0xFF717476),
                      elevation: 6,
                      child: Container(
                        width: 120,
                        padding:  const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child:  Column(
                          children: [
                            Text(time, 
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            ),
                            const SizedBox(height: 5,),
                            Icon(icon,
                            size: 40),
                            const SizedBox(height: 5,),
                            Text(temperature,
                            style: const TextStyle(
                              fontSize: 18
                            ),
                            )
                          ],
                        ),
                      ),
                    );
  }
  }