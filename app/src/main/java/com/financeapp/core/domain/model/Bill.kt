package com.financeapp.core.domain.model
data class Bill(val id: Long = 0, val name: String, val amount: Double, val dueDayOfMonth: Int, val category: String, val isRecurring: Boolean = true, val isPaid: Boolean = false)
