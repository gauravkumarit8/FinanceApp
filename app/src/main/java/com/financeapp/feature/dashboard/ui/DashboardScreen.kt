package com.financeapp.feature.dashboard.ui
import androidx.compose.foundation.layout.*; import androidx.compose.material3.*; import androidx.compose.runtime.*; import androidx.compose.ui.Modifier; import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel; import androidx.navigation.NavController; import com.financeapp.feature.dashboard.viewmodel.DashboardViewModel
@Composable
fun DashboardScreen(navController: NavController, viewModel: DashboardViewModel = hiltViewModel()) {
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text("DashboardScreen", style = MaterialTheme.typography.headlineMedium)
        Spacer(Modifier.height(8.dp))
        Text("Coming soon — wire up viewModel.uiState here", style = MaterialTheme.typography.bodyMedium)
    }
}
