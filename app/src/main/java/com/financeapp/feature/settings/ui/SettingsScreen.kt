package com.financeapp.feature.settings.ui
import androidx.compose.foundation.layout.*; import androidx.compose.material3.*; import androidx.compose.runtime.Composable; import androidx.compose.ui.Modifier; import androidx.compose.ui.unit.dp; import androidx.navigation.NavController
@Composable
fun SettingsScreen(navController: NavController) {
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) { Text("SettingsScreen", style = MaterialTheme.typography.headlineMedium) }
}
