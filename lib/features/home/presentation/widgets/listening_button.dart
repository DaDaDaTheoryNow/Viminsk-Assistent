import 'package:flutter/material.dart';
import '../../../../utils/utils.dart';

class ListeningButton extends StatelessWidget {
  const ListeningButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(60),
        child: Ink(
          width: WindowSize(context).width * 0.4,
          height: WindowSize(context).height * 0.1,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 48, 46, 46),
            borderRadius: BorderRadius.circular(60),
          ),
          child: const Center(
            child: Icon(
              Icons.mic,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
