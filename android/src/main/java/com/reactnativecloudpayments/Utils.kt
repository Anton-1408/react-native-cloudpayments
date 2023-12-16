package com.reactnativecloudpayments

import com.fasterxml.jackson.databind.ObjectMapper
import ru.cloudpayments.sdk.api.models.CloudpaymentsBinInfo
import ru.cloudpayments.sdk.api.models.CloudpaymentsTransactionResponse

fun parseTransactionFromApiToString(results: CloudpaymentsTransactionResponse): String {
  val objectMapper = ObjectMapper();

  return objectMapper.writeValueAsString(results)
}

fun parseBankInfoFromApiToString(results: CloudpaymentsBinInfo): String {
  val objectMapper = ObjectMapper();

  return objectMapper.writeValueAsString(results)
}
