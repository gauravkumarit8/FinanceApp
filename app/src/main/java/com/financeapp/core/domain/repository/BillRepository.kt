package com.financeapp.core.domain.repository
import com.financeapp.core.domain.model.Bill; import kotlinx.coroutines.flow.Flow
interface BillRepository {
    fun getAllBills(): Flow<List<Bill>>
    fun getUnpaidBills(): Flow<List<Bill>>
    fun getTotalMonthlyCommitments(): Flow<Double>
    suspend fun addBill(bill: Bill): Long
    suspend fun updateBill(bill: Bill)
    suspend fun deleteBill(bill: Bill)
    suspend fun markAsPaid(bill: Bill)
}
