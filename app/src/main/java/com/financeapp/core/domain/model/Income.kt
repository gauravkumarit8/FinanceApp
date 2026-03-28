package com.financeapp.core.domain.model
data class Income(val id: Long = 0, val amount: Double, val source: String, val note: String = "", val date: Long = System.currentTimeMillis(), val isAutoDetected: Boolean = false)
