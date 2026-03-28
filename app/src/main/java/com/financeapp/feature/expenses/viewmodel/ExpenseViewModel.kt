package com.financeapp.feature.expenses.viewmodel
import androidx.lifecycle.ViewModel; import androidx.lifecycle.viewModelScope
import com.financeapp.core.domain.model.Expense
import com.financeapp.core.domain.usecase.expense.AddExpenseUseCase; import com.financeapp.core.domain.usecase.expense.DeleteExpenseUseCase; import com.financeapp.core.domain.usecase.expense.GetExpensesUseCase
import com.financeapp.core.utils.DateUtils
import dagger.hilt.android.lifecycle.HiltViewModel; import kotlinx.coroutines.flow.*; import kotlinx.coroutines.launch; import javax.inject.Inject
data class ExpenseUiState(val expenses: List<Expense> = emptyList(), val isLoading: Boolean = true, val errorMessage: String? = null)
@HiltViewModel
class ExpenseViewModel @Inject constructor(private val getExpensesUseCase: GetExpensesUseCase, private val addExpenseUseCase: AddExpenseUseCase, private val deleteExpenseUseCase: DeleteExpenseUseCase) : ViewModel() {
    private val _uiState = MutableStateFlow(ExpenseUiState())
    val uiState: StateFlow<ExpenseUiState> = _uiState.asStateFlow()
    init { val (s, e) = DateUtils.currentMonthRange(); getExpensesUseCase(s, e).onEach { list -> _uiState.update { it.copy(expenses = list, isLoading = false) } }.launchIn(viewModelScope) }
    fun addExpense(expense: Expense) = viewModelScope.launch { addExpenseUseCase(expense).onFailure { err -> _uiState.update { it.copy(errorMessage = err.message) } } }
    fun deleteExpense(expense: Expense) = viewModelScope.launch { deleteExpenseUseCase(expense) }
    fun clearError() = _uiState.update { it.copy(errorMessage = null) }
}
