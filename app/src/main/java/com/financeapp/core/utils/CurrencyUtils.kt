package com.financeapp.core.utils
import java.text.NumberFormat; import java.util.Locale
object CurrencyUtils {
    private val inrFormat = NumberFormat.getCurrencyInstance(Locale("en", "IN"))
    fun formatINR(amount: Double): String = inrFormat.format(amount)
    fun formatCompact(amount: Double): String = when {
        amount >= 100_000 -> "₹${"%.1f".format(amount / 100_000)}L"
        amount >= 1_000   -> "₹${"%.1f".format(amount / 1_000)}K"
        else              -> "₹${"%.0f".format(amount)}"
    }
}
