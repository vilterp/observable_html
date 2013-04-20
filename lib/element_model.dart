library observable_html;

import 'package:observable_datastructures/observable_datastructures.dart';
import 'dart:html';

abstract class HtmlNodeValue<T extends Node> {
  T node;
}

class HtmlElementValue extends HtmlNodeValue<Element> {

  ObservableMap<String, String> attributes;

  HtmlElementValue(String tag, this.attributes) {
    node = new Element.tag(tag);
    attributes.bindToMap(node.attributes);
  }

}

class HtmlTextValue extends HtmlNodeValue<Text> {

  HtmlTextValue(Signal<String> contents) {
    node = new Text(contents.value);
    contents.bindToProperty(node, "data");
  }

}

abstract class HtmlNodeModel<T extends HtmlNodeValue> extends ObservableTreeNode {

  HtmlNodeModel(T node, ObservableList<HtmlNodeModel<T>> children) : super(node, children);

  void bindToContainer(Element container) {
    assert(container.children.isEmpty);
    container.children.add(value.node);
  }

}

class ElementModel extends HtmlNodeModel<HtmlElementValue> {

  ElementModel(HtmlElementValue node, ObservableList<ElementModel> children) : super(node, children) {
    var childNodes = children.mapped((c) => c.value.node);
    childNodes.bindToList(value.node.children);
  }

}

class TextNodeModel extends HtmlNodeModel<HtmlTextValue> {

  TextNodeModel(Signal<String> contents) : super(new HtmlTextValue(contents), ObservableList.EMPTY);

}

var xor = (a,b) => (b && !a) || (a && !b); // ??

ElementModel el(String tag, { ObservableMap<String,Option<String>> attrs,
                              ObservableList<HtmlNodeModel> children,
                              Map<String,Option<String>> attrsC,
                              List<HtmlNodeModel> childrenC}) {
  // TODO: overloading would be nice here. this is not so great.
  if(!xor(?attrs, ?attrsC)) {
    attrsC = {};
  };
  if(!xor(?children, ?childrenC)) {
    childrenC = [];
  };
  var _attrs = ?attrs ? attrs : new ObservableMap.constant(attrsC);
  var _children = ?children ? children : new ObservableList.constant(childrenC);
  return new ElementModel(new HtmlElementValue(tag, _attrs), _children);
}

TextNodeModel text({Signal<String> signal, String constant}) {
  if(!xor(?signal, ?constant)) {
    throw new ArgumentError();
  }
  return new TextNodeModel(?signal ? signal : new Signal.constant(constant));
}

// TODO: SVG
