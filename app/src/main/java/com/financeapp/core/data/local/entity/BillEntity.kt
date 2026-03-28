package com.financeapp.core.data.local.entity
import androidx.room.Entity; import androidx.room.PrimaryKey
@Entity(tableName = "bills")
data class BillEntity(@PrimaryKey(autoGenerate = true) val id: Long = 0, val name: String, val amount: Double, val dueDayOfMonth: Int, val category: String, val isRecurring: Boolean = true, val isPaid: Boolean = false)
