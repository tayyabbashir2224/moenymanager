class IncomeItem {
  int id;
  String name;
  String img;
  IncomeItem({this.img, this.name, this.id});
}

List incomes = [
  IncomeItem(img: 'assets/categories/income/salary.png', name: 'Salary', id: 1),
  IncomeItem(
      img: 'assets/categories/income/freelance.png', name: 'Freelance', id: 2),
  IncomeItem(img: 'assets/categories/income/awards.png', name: 'Awards', id: 3),
  IncomeItem(img: 'assets/categories/income/bonus.png', name: 'Bonus', id: 4),
  IncomeItem(img: 'assets/categories/income/grants.png', name: 'Grants', id: 5),
  IncomeItem(
      img: 'assets/categories/income/interest.png', name: 'Interest', id: 6),
  IncomeItem(
      img: 'assets/categories/income/investments.png',
      name: 'Investments',
      id: 7),
  IncomeItem(
      img: 'assets/categories/income/lottery.png', name: 'Lottery', id: 8),
  IncomeItem(
      img: 'assets/categories/income/refunds.png', name: 'Refunds', id: 9),
  IncomeItem(img: 'assets/categories/income/rent.png', name: 'Rent', id: 10),
  IncomeItem(img: 'assets/categories/income/sale.png', name: 'Sale', id: 11),
  IncomeItem(
      img: 'assets/categories/income/others.png', name: 'Others', id: 12),
];
