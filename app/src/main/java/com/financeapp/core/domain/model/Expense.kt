package com.financeapp.core.domain.model
data class Expense(val id: Long = 0, val amount: Double, val category: String, val merchant: String, val note: String = "", val date: Long = System.currentTimeMillis(), val isAutoDetected: Boolean = false, val accountLast4: String = "")
