package com.financeapp.core.data.local.entity
import androidx.room.Entity; import androidx.room.PrimaryKey
@Entity(tableName = "expenses")
data class ExpenseEntity(@PrimaryKey(autoGenerate = true) val id: Long = 0, val amount: Double, val category: String, val merchant: String, val note: String = "", val date: Long = System.currentTimeMillis(), val isAutoDetected: Boolean = false, val accountLast4: String = "")
