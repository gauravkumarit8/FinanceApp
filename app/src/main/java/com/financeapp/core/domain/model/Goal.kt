package com.financeapp.core.domain.model
data class Goal(val id: Long = 0, val name: String, val targetAmount: Double, val savedAmount: Double = 0.0, val deadline: Long, val emoji: String = "") {
    val progressPercent: Float  get() = (savedAmount / targetAmount).coerceIn(0.0, 1.0).toFloat()
    val isCompleted: Boolean    get() = savedAmount >= targetAmount
    val remainingAmount: Double get() = targetAmount - savedAmount
}
