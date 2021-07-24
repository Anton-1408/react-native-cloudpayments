export interface Parametres3DS {
  transactionId: string;
  paReq: string;
  acsUrl: string;
}
export interface Result3DS {
  TransactionId: string;
  PaRes: string;
}
export interface BankInfo {
  logoUrl: string;
  bankName: string;
}
export interface Product {
  name: string;
  price: string;
}

export type ListenerCryptogramCard = (cryptogram: string) => void;
