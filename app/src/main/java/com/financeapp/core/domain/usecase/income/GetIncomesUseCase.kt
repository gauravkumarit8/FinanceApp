package com.financeapp.core.domain.usecase.income
import com.financeapp.core.domain.repository.IncomeRepository; import javax.inject.Inject
class GetIncomesUseCase @Inject constructor(private val repo: IncomeRepository) {
    operator fun invoke(s: Long, e: Long) = repo.getIncomesByDateRange(s, e)
}
