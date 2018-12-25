import 'dart:async';

class Validator {
  final performUserNameValidation =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (username, sink) {
    if (username.length >= 4) {
      sink.add(username);
    } else {
      sink.addError('Please enter username');
    }
  });

  // final performEmailValidation =
  //     StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
  //   String emailValidationRule =
  //       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  //   RegExp regExp = new RegExp(emailValidationRule);
  //   if (regExp.hasMatch(email)) {
  //     sink.add(email);
  //   } else {
  //     sink.addError('Please enter a valid email address');
  //   }
  // });

  final performPasswordValidation =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (password, sink) {
    // String passwordValidationRule =
    //     '((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#%]).{6,10})';
     String passwordValidationRule =
        '[a-zA-Z0-9]';
    RegExp regExp = new RegExp(passwordValidationRule);

    if (regExp.hasMatch(password)) {
      sink.add(password);
    } else {
      sink.addError(
          'Please enter password');
    }
  });
}
