// class GroceriesModel {
//   int? statusCode;
//   bool? success;
//   String? message;
//   GroceryData? data;

//   GroceriesModel({this.statusCode, this.success, this.message, this.data});

//   GroceriesModel.fromJson(Map<String, dynamic> json) {
//     statusCode = json['statusCode'];
//     success = json['success'];
//     message = json['message'];
//     data = json['data'] != null ? new GroceryData.fromJson(json['data']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['statusCode'] = this.statusCode;
//     data['success'] = this.success;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }

class GroceriesModel {
  List<String>? fruits;
  List<String>? vegetables;
  List<String>? personalCare;
  List<String>? householdCareCleaning;
  List<String>? frozenFood;
  List<String>? beverages;
  List<String>? homeBaking;
  List<String>? snacks;
  List<String>? sugarSweetsChocolates;
  List<String>? herbsSpicesSeasoning;
  List<String>? driedFruitsNutsSeeds;
  List<String>? dairy;
  List<String>? saucesDressingsCondimentsJamsHoneysSyrupsSpreads;
  List<String>? pastaRicePulsesCereals;
  List<String>? cannedFood;
  List<String>? breadAndBakedGoods;
  List<String>? meat;
  List<String>? fishSeafood;
  List<String>? meatAlternatives;

  GroceriesModel(
      {this.fruits,
      this.vegetables,
      this.personalCare,
      this.householdCareCleaning,
      this.frozenFood,
      this.beverages,
      this.homeBaking,
      this.snacks,
      this.sugarSweetsChocolates,
      this.herbsSpicesSeasoning,
      this.driedFruitsNutsSeeds,
      this.dairy,
      this.saucesDressingsCondimentsJamsHoneysSyrupsSpreads,
      this.pastaRicePulsesCereals,
      this.cannedFood,
      this.breadAndBakedGoods,
      this.meat,
      this.fishSeafood,
      this.meatAlternatives});

  GroceriesModel.fromJson(Map<String, dynamic> json) {
    fruits = json['fruits'].cast<String>();
    vegetables = json['vegetables'].cast<String>();
    personalCare = json['personal_care'].cast<String>();
    householdCareCleaning = json['household_care_cleaning'].cast<String>();
    frozenFood = json['frozen_food'].cast<String>();
    beverages = json['beverages'].cast<String>();
    homeBaking = json['home_baking'].cast<String>();
    snacks = json['snacks'].cast<String>();
    sugarSweetsChocolates = json['sugar_sweets_chocolates'].cast<String>();
    herbsSpicesSeasoning = json['herbs_spices_seasoning'].cast<String>();
    driedFruitsNutsSeeds = json['dried_fruits_nuts_seeds'].cast<String>();
    dairy = json['dairy'].cast<String>();
    saucesDressingsCondimentsJamsHoneysSyrupsSpreads =
        json['sauces_dressings_condiments_jams_honeys_syrups_spreads']
            .cast<String>();
    pastaRicePulsesCereals = json['pasta_rice_pulses_cereals'].cast<String>();
    cannedFood = json['canned_food'].cast<String>();
    breadAndBakedGoods = json['bread_and_baked_goods'].cast<String>();
    meat = json['meat'].cast<String>();
    fishSeafood = json['fish_seafood'].cast<String>();
    meatAlternatives = json['meat_alternatives'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fruits'] = this.fruits;
    data['vegetables'] = this.vegetables;
    data['personal_care'] = this.personalCare;
    data['household_care_cleaning'] = this.householdCareCleaning;
    data['frozen_food'] = this.frozenFood;
    data['beverages'] = this.beverages;
    data['home_baking'] = this.homeBaking;
    data['snacks'] = this.snacks;
    data['sugar_sweets_chocolates'] = this.sugarSweetsChocolates;
    data['herbs_spices_seasoning'] = this.herbsSpicesSeasoning;
    data['dried_fruits_nuts_seeds'] = this.driedFruitsNutsSeeds;
    data['dairy'] = this.dairy;
    data['sauces_dressings_condiments_jams_honeys_syrups_spreads'] =
        this.saucesDressingsCondimentsJamsHoneysSyrupsSpreads;
    data['pasta_rice_pulses_cereals'] = this.pastaRicePulsesCereals;
    data['canned_food'] = this.cannedFood;
    data['bread_and_baked_goods'] = this.breadAndBakedGoods;
    data['meat'] = this.meat;
    data['fish_seafood'] = this.fishSeafood;
    data['meat_alternatives'] = this.meatAlternatives;
    return data;
  }
}
