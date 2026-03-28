package com.financeapp.core.domain.usecase.budget
import com.financeapp.core.domain.model.Budget; import com.financeapp.core.domain.repository.BudgetRepository; import kotlinx.coroutines.flow.Flow; import java.util.Calendar; import javax.inject.Inject
class GetBudgetStatusUseCase @Inject constructor(private val repo: BudgetRepository) {
    operator fun invoke(): Flow<List<Budget>> {
        val cal = Calendar.getInstance()
        return repo.getBudgetsForMonth(cal.get(Calendar.MONTH) + 1, cal.get(Calendar.YEAR))
    }
}
