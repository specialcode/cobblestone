part of cobblestone;

/// A set of custom properties available on various components of Tiled maps.
///
/// [MapObject]'s, [Tile]'s, [TileLayer]'s, [ObjectGroup]'s, and [Tilemap]'s can all have properties.
class MapProperties {

  Map<String, dynamic> _properties = {};

  /// Loads a set of properties from TMX data.
  MapProperties(XML.XmlElement properties) {
    _loadProperties(properties);
  }

  /// Loads a set of properties from the children of the given [tag], or creates an empty set for an element without any.
  MapProperties.fromChild(XML.XmlElement tag) {
    var propertiesTag = tag.findElements("properties");
    if(propertiesTag.isNotEmpty) {
      _loadProperties(propertiesTag.first);
    }
  }

  /// Parses properties from the properties tag into this set.
  void _loadProperties(XML.XmlElement properties) {
    for(XML.XmlElement prop in properties.findElements("property")) {
      String type = prop.getAttribute("type");
      String name = prop.getAttribute("name");
      String value = prop.getAttribute("value");
      if(type == "bool") {
        _properties[name] = value == "true";
      } else if(type == "int") {
        _properties[name] = int.parse(value);
      } else if(type == "float") {
        _properties[name] = double.parse(value);
      } else if(type == null) { // Strings are saved without a type
        _properties[name] = prop.getAttribute("value");
      } else if(type == "color" && value.isNotEmpty) {
        Vector4 color = Vector4.zero();
        Colors.fromHexString(value, color);
        _properties[name] = color;
      }
    }
  }

  /// Returns the loaded property with the given name.
  ///
  /// Could be a bool, int, double, String, or Vector4 color.
  dynamic operator [](String name) {
    return _properties[name];
  }

}