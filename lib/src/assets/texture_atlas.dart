part of cobblestone;

Future<Map<String, Texture>> loadAtlas(
    String atlasUrl, Future<Texture> texture) async {
  var atlasData = JSON.decode(await HttpRequest.getString(atlasUrl));
  Texture atlasTexture = await texture;

  Map<String, Texture> atlas = new Map<String, Texture>();
  atlasData.forEach((name, data) {
    atlas[name] = new Texture.clone(atlasTexture);
    atlas[name].setRegion(
        data["rect"][0],
        atlasTexture.height - data["rect"][3] - data["rect"][1],
        data["rect"][2],
        data["rect"][3]);
  });
  return atlas;
}
