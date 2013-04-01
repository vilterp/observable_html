import 'dart:html';
import 'package:observable_datastructures/observable_datastructures.dart';
import 'package:observable_html/element_model.dart';

void main() {
  // start off simple
  var button = query('#button');
  Signal<int> clicks = new Signal.fold(0, button.onMouseUp, (cur, evt) => cur + 1);
//  button.onClick.listen(window.console.log);
  //  clicks.updates.listen(window.console.log); // this causes double events. wtf?!
  var textNode = new TextNodeModel(clicks.map((val) => val.toString()));
  textNode.bindToContainer(query('#clicks-num'));
  ObservableList<MouseEvent> clickLog = new ObservableList.logEvents(button.onClick.map((_) => new DateTime.now()));
  // TODO: keep improving this API...
  var clickList = el('ul', attrsC: {}, children: clickLog.mapped((evt) {
    return el('li', attrsC: {}, childrenC: [
      text(constant: evt.toString())
    ]);
  }));
  clickList.bindToContainer(query('#click-log-container'));
}
