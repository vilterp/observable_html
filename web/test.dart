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
  ObservableList<MouseEvent> clickLog = ObservableList.log(button.onClick.map((_) => new DateTime.now()));
  // TODO: make this API less ridiculously verbose
  var children = clickLog.mapped((evt) {
    // TODO: this is an unmitigated disaster.
    var childs = new ObservableList();
    var res = new ElementModel(new HtmlElementValue('li', new ObservableMap()), childs);
    childs.add(new TextNodeModel(new Signal.constant(evt.toString())));
    return res;
  });
  var clickList = new ElementModel(new HtmlElementValue('ul', new ObservableMap()), children);
  clickList.bindToContainer(query('#click-log-container'));
}
