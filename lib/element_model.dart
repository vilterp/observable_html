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

// TODO: SVG
