package com.financeapp.core.domain.model
data class Budget(val id: Long = 0, val category: String, val limitAmount: Double, val spentAmount: Double = 0.0, val month: Int, val year: Int) {
    val remainingAmount: Double get() = limitAmount - spentAmount
    val progressPercent: Float  get() = (spentAmount / limitAmount).coerceIn(0.0, 1.0).toFloat()
    val isOverBudget: Boolean   get() = spentAmount > limitAmount
}
