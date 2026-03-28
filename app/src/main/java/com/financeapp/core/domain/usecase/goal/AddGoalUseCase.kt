package com.financeapp.core.domain.usecase.goal
import com.financeapp.core.domain.model.Goal; import com.financeapp.core.domain.repository.GoalRepository; import javax.inject.Inject
class AddGoalUseCase @Inject constructor(private val repo: GoalRepository) {
    suspend operator fun invoke(goal: Goal): Result<Long> = runCatching {
        require(goal.targetAmount > 0) { "Target must be greater than zero" }
        require(goal.name.isNotBlank()) { "Name cannot be empty" }
        repo.addGoal(goal)
    }
}
