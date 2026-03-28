package com.financeapp.core.domain.usecase.bill
import com.financeapp.core.domain.model.Bill; import com.financeapp.core.domain.repository.BillRepository; import javax.inject.Inject
class AddBillUseCase @Inject constructor(private val repo: BillRepository) {
    suspend operator fun invoke(bill: Bill): Result<Long> = runCatching {
        require(bill.amount > 0) { "Amount must be greater than zero" }
        require(bill.name.isNotBlank()) { "Bill name cannot be empty" }
        repo.addBill(bill)
    }
}
