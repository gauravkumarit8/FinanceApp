package com.financeapp.sms.parser
object UpiSmsPatterns {
    val BANK_SENDERS = setOf("HDFCBK","ICICIB","SBIINB","AXISBK","KOTAKB","INDBNK","PNBSMS","BOIIND","CANBNK","CENTBK","IDBIBNK","YESBNK","FEDBK","IDFCFB","PAYTM","PHONEPE","GPAY")
    val DEBIT_PATTERNS = listOf(
        Regex("""(?:Rs\.?|INR\s?)([0-9,]+\.?\d*)\s+debited.*?(?:UPI[:\s]+|Info[:\s]+|Merchant[:\s]+)([A-Za-z0-9 &._\-]+)""", RegexOption.IGNORE_CASE),
        Regex("""debited\s+with\s+(?:INR|Rs\.?)\s*([0-9,]+\.?\d*).*?(?:Info[:\s]+|UPI[:\s]+|Merchant[:\s]+)([A-Za-z0-9 &._\-]+)""", RegexOption.IGNORE_CASE),
        Regex("""(?:Rs\.?|INR)\s+([0-9,]+\.?\d*)\s+debited.*?(?:Merchant[:\s]+|at\s+)([A-Za-z0-9 &._\-]+)""", RegexOption.IGNORE_CASE),
        Regex("""sent\s+(?:Rs\.?|INR)\s*([0-9,]+\.?\d*)\s+to\s+([A-Za-z0-9 &._\-]+)\s+via""", RegexOption.IGNORE_CASE),
        Regex("""(?:Rs\.?|INR)\s*([0-9,]+\.?\d*)\s+paid\s+to\s+([A-Za-z0-9 &._\-]+)""", RegexOption.IGNORE_CASE)
    )
    val CREDIT_PATTERNS = listOf(
        Regex("""(?:Rs\.?|INR\s?)([0-9,]+\.?\d*)\s+credited.*?(?:from[:\s]+|by[:\s]+)([A-Za-z0-9 &._\-]+)""", RegexOption.IGNORE_CASE),
        Regex("""credited\s+with\s+(?:INR|Rs\.?)\s*([0-9,]+\.?\d*).*?(?:from[:\s]+)([A-Za-z0-9 &._\-]+)""", RegexOption.IGNORE_CASE),
        Regex("""received\s+(?:Rs\.?|INR)\s*([0-9,]+\.?\d*)\s+from\s+([A-Za-z0-9 &._\-]+)""", RegexOption.IGNORE_CASE)
    )
    val ACCOUNT_PATTERN = Regex("""(?:A/c|a/c|ac|account)\s*[A-Z]{0,4}(\d{4})""", RegexOption.IGNORE_CASE)
    private val CATEGORY_MAP = mapOf(
        "swiggy" to "Food","zomato" to "Food","dominos" to "Food","mcdonald" to "Food","kfc" to "Food",
        "blinkit" to "Groceries","bigbasket" to "Groceries","zepto" to "Groceries","dmart" to "Groceries",
        "uber" to "Transport","ola" to "Transport","rapido" to "Transport","irctc" to "Transport","petrol" to "Transport",
        "netflix" to "Entertainment","spotify" to "Entertainment","prime" to "Entertainment","hotstar" to "Entertainment",
        "amazon" to "Shopping","flipkart" to "Shopping","myntra" to "Shopping","meesho" to "Shopping",
        "pharmacy" to "Health","apollo" to "Health","medplus" to "Health","practo" to "Health","1mg" to "Health",
        "electricity" to "Utilities","airtel" to "Utilities","jio" to "Utilities","bsnl" to "Utilities",
        "emi" to "EMI / Loans","loan" to "EMI / Loans","lic" to "Insurance",
        "makemytrip" to "Travel","goibibo" to "Travel","cleartrip" to "Travel"
    )
    fun inferCategory(merchant: String): String = CATEGORY_MAP.entries.firstOrNull { merchant.lowercase().contains(it.key) }?.value ?: "Others"
}
