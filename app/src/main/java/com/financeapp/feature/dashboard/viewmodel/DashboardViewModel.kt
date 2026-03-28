package com.financeapp.feature.dashboard.viewmodel
import androidx.lifecycle.ViewModel; import androidx.lifecycle.viewModelScope
import com.financeapp.core.data.local.dao.CategoryTotal; import com.financeapp.core.domain.model.Expense
import com.financeapp.core.domain.repository.ExpenseRepository; import com.financeapp.core.domain.repository.IncomeRepository
import com.financeapp.core.utils.DateUtils
import dagger.hilt.android.lifecycle.HiltViewModel; import kotlinx.coroutines.flow.*; import javax.inject.Inject
data class DashboardUiState(val totalSpent: Double = 0.0, val totalIncome: Double = 0.0, val netSavings: Double = 0.0, val recentExpenses: List<Expense> = emptyList(), val categoryTotals: List<CategoryTotal> = emptyList(), val isLoading: Boolean = true)
@HiltViewModel
class DashboardViewModel @Inject constructor(private val expenseRepo: ExpenseRepository, private val incomeRepo: IncomeRepository) : ViewModel() {
    private val _uiState = MutableStateFlow(DashboardUiState())
    val uiState: StateFlow<DashboardUiState> = _uiState.asStateFlow()
    init { load() }
    private fun load() {
        val (s, e) = DateUtils.currentMonthRange()
        combine(expenseRepo.getTotalForPeriod(s, e), incomeRepo.getTotalForPeriod(s, e), expenseRepo.getExpensesByDateRange(s, e), expenseRepo.getCategoryTotals(s, e)) { spent, income, expenses, cats ->
            DashboardUiState(spent, income, income - spent, expenses.take(5), cats, false)
        }.onEach { _uiState.value = it }.launchIn(viewModelScope)
    }
}
