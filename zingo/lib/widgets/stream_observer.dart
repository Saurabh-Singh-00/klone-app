import 'package:flutter/material.dart';

class StreamObserver<T> extends StatelessWidget {
  final Function onError;
  final Function onSuccess;
  final Function onWaiting;
  final Stream<T> stream;

  Function get _defaultOnWaiting =>
      (BuildContext context) => CircularProgressIndicator();

  Function get _defaultOnError =>
      (BuildContext context, String error) => Text(error);

  const StreamObserver(
      {Key key,
      this.onError,
      @required this.onSuccess,
      @required this.stream,
      this.onWaiting})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          return onError != null
              ? onError(context, snapshot.error)
              : _defaultOnError(context, snapshot.error.toString());
        }
        if (snapshot.hasData) {
          return onSuccess(context, snapshot.data);
        }
        return onWaiting != null
            ? onWaiting(context)
            : _defaultOnWaiting(context);
      },
    );
  }
}
