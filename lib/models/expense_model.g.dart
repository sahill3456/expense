part of 'expense_model.dart';

ExpenseModelAdapter _$ExpenseModelAdapter = ExpenseModelAdapter();

class ExpenseModelAdapter extends TypeAdapter<ExpenseModel> {
  @override
  final typeId = 0;

  @override
  ExpenseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      final fieldId = reader.readByte();
      fields[fieldId] = reader.read();
    }
    return ExpenseModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      amount: fields[2] as double,
      category: fields[3] as String,
      description: fields[4] as String,
      date: fields[5] as DateTime,
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime?,
      isRecurring: fields[8] as bool? ?? false,
      recurringFrequency: fields[9] as String?,
      sharedWith: (fields[10] as List?)?.cast<String>(),
      splitAmount: fields[11] as double?,
      paymentMethod: fields[12] as String?,
      tags: fields[13] as String?,
      attachmentUrl: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.isRecurring)
      ..writeByte(9)
      ..write(obj.recurringFrequency)
      ..writeByte(10)
      ..write(obj.sharedWith)
      ..writeByte(11)
      ..write(obj.splitAmount)
      ..writeByte(12)
      ..write(obj.paymentMethod)
      ..writeByte(13)
      ..write(obj.tags)
      ..writeByte(14)
      ..write(obj.attachmentUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

extension ExpenseModelJsonExt on ExpenseModel {
  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'amount': amount,
        'category': category,
        'description': description,
        'date': date.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'isRecurring': isRecurring,
        'recurringFrequency': recurringFrequency,
        'sharedWith': sharedWith,
        'splitAmount': splitAmount,
        'paymentMethod': paymentMethod,
        'tags': tags,
        'attachmentUrl': attachmentUrl,
      };

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      isRecurring: json['isRecurring'] as bool? ?? false,
      recurringFrequency: json['recurringFrequency'] as String?,
      sharedWith: (json['sharedWith'] as List<dynamic>?)?.cast<String>(),
      splitAmount: (json['splitAmount'] as num?)?.toDouble(),
      paymentMethod: json['paymentMethod'] as String?,
      tags: json['tags'] as String?,
      attachmentUrl: json['attachmentUrl'] as String?,
    );
  }
}
