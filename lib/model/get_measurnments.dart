class Measurement {
  int? id;
  String? tailorId;
  String? productId;
  String? canvasPoints;
  String? description;
  String? createdAt;
  String? updatedAt;
  MeasurementProduct? measurementProduct;

  Measurement(
      {this.id,
      this.tailorId,
      this.productId,
      this.canvasPoints,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.measurementProduct});

  Measurement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tailorId = json['tailor_id'];
    productId = json['product_id'];
    canvasPoints = json['canvas_points'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    measurementProduct = json['measurement_product'] != null
        ? new MeasurementProduct.fromJson(json['measurement_product'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tailor_id'] = this.tailorId;
    data['product_id'] = this.productId;
    data['canvas_points'] = this.canvasPoints;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.measurementProduct != null) {
      data['measurement_product'] = this.measurementProduct!.toJson();
    }
    return data;
  }
}

class MeasurementProduct {
  int? id;
  String? userId;
  String? name;
  String? createdAt;
  String? updatedAt;

  MeasurementProduct(
      {this.id, this.userId, this.name, this.createdAt, this.updatedAt});

  MeasurementProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
