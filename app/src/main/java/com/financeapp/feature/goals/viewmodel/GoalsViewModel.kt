package com.financeapp.feature.goals.viewmodel
import androidx.lifecycle.ViewModel; import androidx.lifecycle.viewModelScope
import com.financeapp.core.domain.model.Goal
import com.financeapp.core.domain.usecase.goal.AddGoalUseCase; import com.financeapp.core.domain.usecase.goal.GetGoalsUseCase
import dagger.hilt.android.lifecycle.HiltViewModel; import kotlinx.coroutines.flow.*; import kotlinx.coroutines.launch; import javax.inject.Inject
data class GoalsUiState(val goals: List<Goal> = emptyList(), val isLoading: Boolean = true)
@HiltViewModel
class GoalsViewModel @Inject constructor(private val getGoalsUseCase: GetGoalsUseCase, private val addGoalUseCase: AddGoalUseCase) : ViewModel() {
    private val _uiState = MutableStateFlow(GoalsUiState())
    val uiState: StateFlow<GoalsUiState> = _uiState.asStateFlow()
    init { getGoalsUseCase().onEach { list -> _uiState.update { it.copy(goals = list, isLoading = false) } }.launchIn(viewModelScope) }
    fun addGoal(goal: Goal) = viewModelScope.launch { addGoalUseCase(goal) }
}
