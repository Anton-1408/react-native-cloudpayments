export const API_URL = 'https://api.cloudpayments.ru/';

export enum Currency {
  ruble = 'RUB', //    Российский рубль
  euro = 'EUR', //    Евро
  usd = 'USD', //    Доллар США
  gbp = 'GBP', //    Фунт стерлингов
  uah = 'UAH', //    Украинская гривна
  byn = 'BYN', //    Белорусский рубль
  kzt = 'KZT', //    Казахский тенге
  azn = 'AZN', //    Азербайджанский манат
  chf = 'CHF', //    Швейцарский франк
  czk = 'CZK', //    Чешская крона
  cad = 'CAD', //    Канадский доллар
  pln = 'PLN', //    Польский злотый
  sek = 'SEK', //    Шведская крона
  tur = 'TRY', //    Турецкая лира
  cny = 'CNY', //    Китайский юань
  inr = 'INR', //    Индийская рупия
  brl = 'BRL', //    Бразильский реал
  zar = 'ZAR', //    Южноафриканский рэнд
  uzs = 'UZS', //    Узбекский сум
  bgl = 'BGL', //    Болгарский лев
}

export enum PAYMENT_NETWORK {
  visa = 'VISA',
  masterCard = 'MASTERCARD',
  amex = 'AMEX',
  discover = 'DISCOVER',
  interac = 'INTERAC',
  jcb = 'JCB',
  mir = 'MIR',
}
