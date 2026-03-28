package com.financeapp.core.data.local.entity
import androidx.room.Entity; import androidx.room.PrimaryKey
@Entity(tableName = "incomes")
data class IncomeEntity(@PrimaryKey(autoGenerate = true) val id: Long = 0, val amount: Double, val source: String, val note: String = "", val date: Long = System.currentTimeMillis(), val isAutoDetected: Boolean = false)
