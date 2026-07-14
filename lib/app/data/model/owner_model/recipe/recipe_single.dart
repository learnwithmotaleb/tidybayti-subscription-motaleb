class RecipeSingleData {
  String? id;
  String? recipeName;
  String? recipeImage;
  String? cookingTime;
  String? description;
  List<String>? ingredients;
  List<String>? steps;
  List<String>? tags;
  bool? isFavorite;

  // ✅ MATCH BACKEND FIELD NAMES
  String? source;  // Backend uses "source" instead of "fileType"
  String? url;     // Backend uses "url" instead of "fileUrl"
  String? file;    // Backend uses "file" instead of "localFilePath"

  RecipeSingleData({
    this.id,
    this.recipeName,
    this.recipeImage,
    this.cookingTime,
    this.description,
    this.ingredients,
    this.steps,
    this.tags,
    this.isFavorite,
    this.source,
    this.url,
    this.file,
  });

  factory RecipeSingleData.fromJson(Map<String, dynamic> json) {
    return RecipeSingleData(
      id: json['_id'] ?? json['id'],
      recipeName: json['recipeName'],
      recipeImage: json['recipeImage'],
      cookingTime: json['cookingTime'],
      description: json['description'],
      ingredients: json['ingredients'] != null
          ? List<String>.from(json['ingredients'])
          : [],
      steps: json['steps'] != null
          ? List<String>.from(json['steps'])
          : [],
      tags: json['tags'] != null
          ? List<String>.from(json['tags'])
          : [],
      isFavorite: json['isFavorite'] ?? false,

      // ✅ BACKEND FIELDS
      source: json['source'] ?? 'normal',
      url: json['url'],
      file: json['file'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'recipeName': recipeName,
      'recipeImage': recipeImage,
      'cookingTime': cookingTime,
      'description': description,
      'ingredients': ingredients,
      'steps': steps,
      'tags': tags,
      'isFavorite': isFavorite,
      'source': source,
      'url': url,
      'file': file,
    };
  }
}