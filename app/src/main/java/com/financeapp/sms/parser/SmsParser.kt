package com.financeapp.sms.parser
import com.financeapp.core.domain.model.Expense; import com.financeapp.core.domain.model.Income
enum class SmsType { DEBIT, CREDIT, UNKNOWN }
data class ParsedSms(val type: SmsType, val amount: Double, val party: String, val accountLast4: String, val category: String)
object SmsParser {
    fun parse(sender: String, body: String): ParsedSms? {
        if (UpiSmsPatterns.BANK_SENDERS.none { sender.uppercase().contains(it) }) return null
        for (p in UpiSmsPatterns.DEBIT_PATTERNS) {
            val m = p.find(body) ?: continue
            val amount = m.groupValues[1].replace(",","").toDoubleOrNull() ?: continue
            val merchant = m.groupValues[2].trim().take(40)
            val account = UpiSmsPatterns.ACCOUNT_PATTERN.find(body)?.groupValues?.get(1) ?: ""
            return ParsedSms(SmsType.DEBIT, amount, merchant, account, UpiSmsPatterns.inferCategory(merchant))
        }
        for (p in UpiSmsPatterns.CREDIT_PATTERNS) {
            val m = p.find(body) ?: continue
            val amount = m.groupValues[1].replace(",","").toDoubleOrNull() ?: continue
            val source = m.groupValues[2].trim().take(40)
            val account = UpiSmsPatterns.ACCOUNT_PATTERN.find(body)?.groupValues?.get(1) ?: ""
            return ParsedSms(SmsType.CREDIT, amount, source, account, "Income")
        }
        return null
    }
    fun toExpense(p: ParsedSms) = Expense(amount = p.amount, category = p.category, merchant = p.party, note = "Auto-detected via UPI SMS", date = System.currentTimeMillis(), isAutoDetected = true, accountLast4 = p.accountLast4)
    fun toIncome(p: ParsedSms) = Income(amount = p.amount, source = p.party, note = "Auto-detected via UPI SMS", date = System.currentTimeMillis(), isAutoDetected = true)
}
