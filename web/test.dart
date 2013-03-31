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
  var test = new ObservableList.constant([1,2,3]);
  var test2 = test.mapped((x) => x + 1);
  // TODO: make this API less ridiculously verbose
  var children = clickLog.mapped((evt) {
    return new ElementModel(new HtmlElementValue('li', ObservableMap.EMPTY), new ObservableList.constant([
      new TextNodeModel(new Signal.constant(evt.toString()))
    ]));
  });
  var clickList = new ElementModel(new HtmlElementValue('ul', ObservableMap.EMPTY), children);
  clickList.bindToContainer(query('#click-log-container'));
}
