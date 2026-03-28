package com.financeapp.core.domain.usecase.bill
import com.financeapp.core.domain.repository.BillRepository; import javax.inject.Inject
class GetBillsUseCase @Inject constructor(private val repo: BillRepository) {
    operator fun invoke() = repo.getAllBills()
}
