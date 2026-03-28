package com.financeapp.feature.budget.viewmodel
import androidx.lifecycle.ViewModel; import androidx.lifecycle.viewModelScope
import com.financeapp.core.domain.model.Budget
import com.financeapp.core.domain.usecase.budget.AddBudgetUseCase; import com.financeapp.core.domain.usecase.budget.GetBudgetStatusUseCase
import dagger.hilt.android.lifecycle.HiltViewModel; import kotlinx.coroutines.flow.*; import kotlinx.coroutines.launch; import javax.inject.Inject
data class BudgetUiState(val budgets: List<Budget> = emptyList(), val isLoading: Boolean = true, val errorMessage: String? = null)
@HiltViewModel
class BudgetViewModel @Inject constructor(private val getBudgetStatusUseCase: GetBudgetStatusUseCase, private val addBudgetUseCase: AddBudgetUseCase) : ViewModel() {
    private val _uiState = MutableStateFlow(BudgetUiState())
    val uiState: StateFlow<BudgetUiState> = _uiState.asStateFlow()
    init { getBudgetStatusUseCase().onEach { list -> _uiState.update { it.copy(budgets = list, isLoading = false) } }.launchIn(viewModelScope) }
    fun addBudget(budget: Budget) = viewModelScope.launch { addBudgetUseCase(budget).onFailure { err -> _uiState.update { it.copy(errorMessage = err.message) } } }
}
