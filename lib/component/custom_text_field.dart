import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_todo_with_dashboard/consts/colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String initialValue;

  //true -> 시간, false -> 내용
  final bool isTime;
  final FormFieldSetter<String> onSaved;

  const CustomTextField({
    required this.onSaved,
    required this.label,
    required this.isTime,
    required this.initialValue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 7.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: CalendarPrimaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (isTime) renderTextField(),
          if (!isTime)
            Expanded(
              child: renderTextField(),
            ),
        ],
      ),
    );
  }

  Widget renderTextField() {
    return TextFormField(
      onSaved: onSaved,
      //null이 return되면 에러가 없다.
      //에러가 있으면 에러가 String 값으로 리턴된다.
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return '값을 입력해 주세요.';
        }

        if (isTime) {
          int time = int.parse(val);

          if (time < 0) {
            return '0 이상의 숫자를 입력해 주세요.';
          }
          if (time > 24) {
            return '24 이하의 숫자를 입력해 주세요.';
          }
        }

        return null;
      },
      maxLines: isTime ? 1 : null,
      expands: !isTime,
      initialValue: initialValue,
      maxLength: (isTime == false) ? 500 : null,
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      inputFormatters: isTime
          ? [
              FilteringTextInputFormatter.digitsOnly,
            ]
          : [],
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[300],
        suffixText: isTime ? '시' : null,
      ),
    );
  }
}
