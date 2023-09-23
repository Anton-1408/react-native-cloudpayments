//
//  Utils.swift
//  CloudpaymentsSdk
//
//  Created by Anton Votinov on 22.09.2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation
import Cloudpayments;

func parseDictionaryToStruct<T: Decodable>(dictionary: Dictionary<String, Any>, type: T.Type) -> T? {
    do {
        let dataFromDictionaryToJSON = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)

        let data = try JSONDecoder().decode(type.self, from: dataFromDictionaryToJSON)

        return data
    } catch {
        print("parseDictionaryToStruct", error)
        return nil
    }
}


func parseResponseFromApiToDictionary(response: TransactionResponse) -> String {
  let jsonEncode = JSONEncoder();

  guard let jsonData = try? jsonEncode.encode(response) else {
    return "Response is empty";
  };

  let jsonString = String(data: jsonData, encoding: .utf8)

  return jsonString ?? "Response is empty";
}
