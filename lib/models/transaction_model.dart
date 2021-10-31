class Transaction {
  final int id;
  final String name;
  final String category;
  final double amount;
  final String memo;
  final int date;
  final int month;
  final int year;
  final String imgSrc;
  Transaction(
      {this.memo,
      this.month,
      this.year,
      this.name,
      this.date,
      this.id,
      this.amount,
      this.category,
      this.imgSrc});
}
