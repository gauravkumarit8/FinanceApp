package com.financeapp.core.data.repository
import com.financeapp.core.data.local.dao.BillDao; import com.financeapp.core.data.local.entity.BillEntity
import com.financeapp.core.domain.model.Bill; import com.financeapp.core.domain.repository.BillRepository
import kotlinx.coroutines.flow.map; import javax.inject.Inject
class BillRepositoryImpl @Inject constructor(private val dao: BillDao) : BillRepository {
    override fun getAllBills() = dao.getAllBills().map { it.map { b -> b.toDomain() } }
    override fun getUnpaidBills() = dao.getUnpaidBills().map { it.map { b -> b.toDomain() } }
    override fun getTotalMonthlyCommitments() = dao.getTotalMonthlyCommitments().map { it ?: 0.0 }
    override suspend fun addBill(bill: Bill) = dao.insert(bill.toEntity())
    override suspend fun updateBill(bill: Bill) = dao.update(bill.toEntity())
    override suspend fun deleteBill(bill: Bill) = dao.delete(bill.toEntity())
    override suspend fun markAsPaid(bill: Bill) = dao.update(bill.toEntity().copy(isPaid = true))
    private fun BillEntity.toDomain() = Bill(id, name, amount, dueDayOfMonth, category, isRecurring, isPaid)
    private fun Bill.toEntity() = BillEntity(id, name, amount, dueDayOfMonth, category, isRecurring, isPaid)
}
