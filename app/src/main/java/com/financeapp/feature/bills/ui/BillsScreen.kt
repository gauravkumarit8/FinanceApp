package com.financeapp.feature.bills.ui
import androidx.compose.foundation.layout.*; import androidx.compose.material3.*; import androidx.compose.runtime.Composable; import androidx.compose.ui.Modifier; import androidx.compose.ui.unit.dp; import androidx.navigation.NavController
@Composable
fun BillsScreen(navController: NavController) {
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) { Text("BillsScreen", style = MaterialTheme.typography.headlineMedium) }
}
