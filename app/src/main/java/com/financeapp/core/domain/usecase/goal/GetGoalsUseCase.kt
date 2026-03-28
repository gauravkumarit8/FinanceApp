package com.financeapp.core.domain.usecase.goal
import com.financeapp.core.domain.repository.GoalRepository; import javax.inject.Inject
class GetGoalsUseCase @Inject constructor(private val repo: GoalRepository) {
    operator fun invoke() = repo.getAllGoals()
}
