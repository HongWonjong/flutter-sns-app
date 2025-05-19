import 'package:flutter/material.dart';

class AddTagWidget extends StatelessWidget {
  const AddTagWidget({required this.tags, super.key});
  final List<String> tags;


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TextField(
            onSubmitted: (value) {
              tags.add(value);
            },
          ),
          SizedBox(height: 5,),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            constraints: BoxConstraints(maxHeight: 50, maxWidth: double.infinity),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Text(tags[index]);
              },
              separatorBuilder: (context, index) {
                return SizedBox(width: 5);
              },
              itemCount: tags.length,
            ),
          ),
        ],
      ),
    );
  }
}
