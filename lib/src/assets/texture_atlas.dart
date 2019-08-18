part of cobblestone;

/// Loads a JSON texture atlas, in the format generated by the LibGDX texture packer.
Future<Map<String, Texture>> loadAtlas(
    String atlasUrl, FutureOr<Texture> texture) async {
  var atlasFile = await HttpRequest.getString(atlasUrl);

  List page = _atlasParser.parse(atlasFile).value.first;
  List regions = page[2];

  Texture atlasTexture = await texture;

  Map<String, Texture> atlas = Map.fromIterable(regions, key: (region) => region[0], value: (region) {
    List vars = region[1];
    List xy = vars.firstWhere((variable) => variable[0] == "xy")[1];
    List size = vars.firstWhere((variable) => variable[0] == "size")[1];

    Texture regionTexture = Texture.clone(atlasTexture);
    regionTexture.setRegion(xy[0], regionTexture.height - size[1] - xy[1], size[0], size[1]);

    return regionTexture;
  });

  return atlas;
}
