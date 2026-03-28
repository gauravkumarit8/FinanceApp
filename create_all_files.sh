#!/bin/bash
set -e
echo "📝 Creating all project files..."
PKG=app/src/main/java/com/financeapp

# ── ROOT CONFIG ───────────────────────────────────────────────────────────────
cat > settings.gradle.kts << 'EOF'
pluginManagement {
    repositories { google(); mavenCentral(); gradlePluginPortal() }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories { google(); mavenCentral() }
}
rootProject.name = "FinanceApp"
include(":app")
EOF

cat > build.gradle.kts << 'EOF'
plugins {
    alias(libs.plugins.android.application) apply false
    alias(libs.plugins.kotlin.android)      apply false
    alias(libs.plugins.kotlin.compose)      apply false
    alias(libs.plugins.hilt)                apply false
    alias(libs.plugins.ksp)                 apply false
    alias(libs.plugins.google.services)     apply false
}
EOF

cat > gradle.properties << 'EOF'
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
kotlin.code.style=official
android.nonTransitiveRClass=true
EOF

cat > gradle/libs.versions.toml << 'EOF'
[versions]
agp    = "8.5.2"
kotlin = "2.0.20"
ksp    = "2.0.20-1.0.25"
hilt   = "2.52"

[plugins]
android-application = { id = "com.android.application",            version.ref = "agp"    }
kotlin-android       = { id = "org.jetbrains.kotlin.android",       version.ref = "kotlin" }
kotlin-compose       = { id = "org.jetbrains.kotlin.plugin.compose",version.ref = "kotlin" }
hilt                 = { id = "com.google.dagger.hilt.android",     version.ref = "hilt"   }
ksp                  = { id = "com.google.devtools.ksp",            version.ref = "ksp"    }
google-services      = { id = "com.google.gms.google-services",     version = "4.4.2"      }
EOF

cat > gradle/wrapper/gradle-wrapper.properties << 'EOF'
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.9-bin.zip
networkTimeout=10000
validateDistributionUrl=true
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
EOF

cat > .gitignore << 'EOF'
*.iml
.gradle/
/local.properties
/.idea/
.DS_Store
/build/
*.apk
*.aab
google-services.json
keystore.jks
*.keystore
EOF

# ── APP build.gradle.kts ─────────────────────────────────────────────────────
cat > app/build.gradle.kts << 'EOF'
plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.android)
    alias(libs.plugins.kotlin.compose)
    alias(libs.plugins.hilt)
    alias(libs.plugins.ksp)
    alias(libs.plugins.google.services)
}
android {
    namespace  = "com.financeapp"
    compileSdk = 35
    defaultConfig {
        applicationId = "com.financeapp"
        minSdk        = 26
        targetSdk     = 35
        versionCode   = 1
        versionName   = "1.0.0"
    }
    buildTypes {
        release {
            isMinifyEnabled = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions { jvmTarget = "17" }
    buildFeatures { compose = true }
}
dependencies {
    val composeBom = platform("androidx.compose:compose-bom:2024.09.00")
    implementation(composeBom)
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.activity:activity-compose:1.9.2")
    implementation("androidx.lifecycle:lifecycle-viewmodel-compose:2.8.6")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.8.6")
    implementation("androidx.navigation:navigation-compose:2.8.1")
    implementation("androidx.room:room-runtime:2.6.1")
    implementation("androidx.room:room-ktx:2.6.1")
    ksp("androidx.room:room-compiler:2.6.1")
    implementation("com.google.dagger:hilt-android:2.52")
    ksp("com.google.dagger:hilt-compiler:2.52")
    implementation("androidx.hilt:hilt-navigation-compose:1.2.0")
    implementation(platform("com.google.firebase:firebase-bom:33.3.0"))
    implementation("com.google.firebase:firebase-auth-ktx")
    implementation("com.google.firebase:firebase-firestore-ktx")
    implementation("com.patrykandpatrick.vico:compose-m3:2.0.0-alpha.28")
    implementation("androidx.biometric:biometric:1.2.0-alpha05")
    implementation("androidx.security:security-crypto:1.1.0-alpha06")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.8.1")
    implementation("androidx.datastore:datastore-preferences:1.1.1")
    testImplementation("junit:junit:4.13.2")
    testImplementation("io.mockk:mockk:1.13.12")
    testImplementation("org.jetbrains.kotlinx:kotlinx-coroutines-test:1.8.1")
    androidTestImplementation("androidx.compose.ui:ui-test-junit4")
    debugImplementation("androidx.compose.ui:ui-tooling")
}
EOF

# ── MANIFEST ─────────────────────────────────────────────────────────────────
cat > app/src/main/AndroidManifest.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.RECEIVE_SMS" />
    <uses-permission android:name="android.permission.READ_SMS" />
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.USE_BIOMETRIC" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    <application
        android:name=".FinanceApp"
        android:allowBackup="true"
        android:label="FinanceApp"
        android:theme="@style/Theme.FinanceApp">
        <activity android:name=".MainActivity" android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
        <receiver
            android:name=".sms.receiver.SmsReceiver"
            android:exported="true"
            android:permission="android.permission.BROADCAST_SMS">
            <intent-filter android:priority="999">
                <action android:name="android.provider.Telephony.SMS_RECEIVED" />
            </intent-filter>
        </receiver>
    </application>
</manifest>
EOF

# ── RES ───────────────────────────────────────────────────────────────────────
cat > app/src/main/res/values/themes.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="Theme.FinanceApp" parent="Theme.Material3.DayNight.NoActionBar" />
</resources>
EOF
cat > app/src/main/res/values/strings.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">FinanceApp</string>
</resources>
EOF

# ── KOTLIN FILES ──────────────────────────────────────────────────────────────

# Entry points
cat > $PKG/FinanceApp.kt << 'EOF'
package com.financeapp
import android.app.Application
import dagger.hilt.android.HiltAndroidApp
@HiltAndroidApp
class FinanceApp : Application()
EOF

cat > $PKG/MainActivity.kt << 'EOF'
package com.financeapp
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import com.financeapp.navigation.AppNavGraph
import dagger.hilt.android.AndroidEntryPoint
@AndroidEntryPoint
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent { AppNavGraph() }
    }
}
EOF

# Navigation
cat > $PKG/navigation/Screen.kt << 'EOF'
package com.financeapp.navigation
sealed class Screen(val route: String) {
    object Dashboard  : Screen("dashboard")
    object Expenses   : Screen("expenses")
    object AddExpense : Screen("add_expense")
    object Budget     : Screen("budget")
    object Income     : Screen("income")
    object Goals      : Screen("goals")
    object Reports    : Screen("reports")
    object Bills      : Screen("bills")
    object Settings   : Screen("settings")
}
EOF

cat > $PKG/navigation/AppNavGraph.kt << 'EOF'
package com.financeapp.navigation
import androidx.compose.runtime.Composable
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.financeapp.feature.budget.ui.BudgetScreen
import com.financeapp.feature.dashboard.ui.DashboardScreen
import com.financeapp.feature.expenses.ui.AddExpenseScreen
import com.financeapp.feature.expenses.ui.ExpenseListScreen
import com.financeapp.feature.goals.ui.GoalsScreen
import com.financeapp.feature.income.ui.IncomeScreen
import com.financeapp.feature.reports.ui.ReportsScreen
import com.financeapp.feature.bills.ui.BillsScreen
import com.financeapp.feature.settings.ui.SettingsScreen
@Composable
fun AppNavGraph() {
    val navController = rememberNavController()
    NavHost(navController = navController, startDestination = Screen.Dashboard.route) {
        composable(Screen.Dashboard.route)  { DashboardScreen(navController) }
        composable(Screen.Expenses.route)   { ExpenseListScreen(navController) }
        composable(Screen.AddExpense.route) { AddExpenseScreen(navController) }
        composable(Screen.Budget.route)     { BudgetScreen(navController) }
        composable(Screen.Income.route)     { IncomeScreen(navController) }
        composable(Screen.Goals.route)      { GoalsScreen(navController) }
        composable(Screen.Reports.route)    { ReportsScreen(navController) }
        composable(Screen.Bills.route)      { BillsScreen(navController) }
        composable(Screen.Settings.route)   { SettingsScreen(navController) }
    }
}
EOF

# Domain Models
cat > $PKG/core/domain/model/Expense.kt << 'EOF'
package com.financeapp.core.domain.model
data class Expense(val id: Long = 0, val amount: Double, val category: String, val merchant: String, val note: String = "", val date: Long = System.currentTimeMillis(), val isAutoDetected: Boolean = false, val accountLast4: String = "")
EOF
cat > $PKG/core/domain/model/Budget.kt << 'EOF'
package com.financeapp.core.domain.model
data class Budget(val id: Long = 0, val category: String, val limitAmount: Double, val spentAmount: Double = 0.0, val month: Int, val year: Int) {
    val remainingAmount: Double get() = limitAmount - spentAmount
    val progressPercent: Float  get() = (spentAmount / limitAmount).coerceIn(0.0, 1.0).toFloat()
    val isOverBudget: Boolean   get() = spentAmount > limitAmount
}
EOF
cat > $PKG/core/domain/model/Income.kt << 'EOF'
package com.financeapp.core.domain.model
data class Income(val id: Long = 0, val amount: Double, val source: String, val note: String = "", val date: Long = System.currentTimeMillis(), val isAutoDetected: Boolean = false)
EOF
cat > $PKG/core/domain/model/Goal.kt << 'EOF'
package com.financeapp.core.domain.model
data class Goal(val id: Long = 0, val name: String, val targetAmount: Double, val savedAmount: Double = 0.0, val deadline: Long, val emoji: String = "") {
    val progressPercent: Float  get() = (savedAmount / targetAmount).coerceIn(0.0, 1.0).toFloat()
    val isCompleted: Boolean    get() = savedAmount >= targetAmount
    val remainingAmount: Double get() = targetAmount - savedAmount
}
EOF
cat > $PKG/core/domain/model/Bill.kt << 'EOF'
package com.financeapp.core.domain.model
data class Bill(val id: Long = 0, val name: String, val amount: Double, val dueDayOfMonth: Int, val category: String, val isRecurring: Boolean = true, val isPaid: Boolean = false)
EOF

# Entities
cat > $PKG/core/data/local/entity/ExpenseEntity.kt << 'EOF'
package com.financeapp.core.data.local.entity
import androidx.room.Entity; import androidx.room.PrimaryKey
@Entity(tableName = "expenses")
data class ExpenseEntity(@PrimaryKey(autoGenerate = true) val id: Long = 0, val amount: Double, val category: String, val merchant: String, val note: String = "", val date: Long = System.currentTimeMillis(), val isAutoDetected: Boolean = false, val accountLast4: String = "")
EOF
cat > $PKG/core/data/local/entity/BudgetEntity.kt << 'EOF'
package com.financeapp.core.data.local.entity
import androidx.room.Entity; import androidx.room.PrimaryKey
@Entity(tableName = "budgets")
data class BudgetEntity(@PrimaryKey(autoGenerate = true) val id: Long = 0, val category: String, val limitAmount: Double, val month: Int, val year: Int)
EOF
cat > $PKG/core/data/local/entity/IncomeEntity.kt << 'EOF'
package com.financeapp.core.data.local.entity
import androidx.room.Entity; import androidx.room.PrimaryKey
@Entity(tableName = "incomes")
data class IncomeEntity(@PrimaryKey(autoGenerate = true) val id: Long = 0, val amount: Double, val source: String, val note: String = "", val date: Long = System.currentTimeMillis(), val isAutoDetected: Boolean = false)
EOF
cat > $PKG/core/data/local/entity/GoalEntity.kt << 'EOF'
package com.financeapp.core.data.local.entity
import androidx.room.Entity; import androidx.room.PrimaryKey
@Entity(tableName = "goals")
data class GoalEntity(@PrimaryKey(autoGenerate = true) val id: Long = 0, val name: String, val targetAmount: Double, val savedAmount: Double = 0.0, val deadline: Long, val emoji: String = "")
EOF
cat > $PKG/core/data/local/entity/BillEntity.kt << 'EOF'
package com.financeapp.core.data.local.entity
import androidx.room.Entity; import androidx.room.PrimaryKey
@Entity(tableName = "bills")
data class BillEntity(@PrimaryKey(autoGenerate = true) val id: Long = 0, val name: String, val amount: Double, val dueDayOfMonth: Int, val category: String, val isRecurring: Boolean = true, val isPaid: Boolean = false)
EOF
cat > $PKG/core/data/local/converter/DateConverter.kt << 'EOF'
package com.financeapp.core.data.local.converter
import androidx.room.TypeConverter; import java.util.Date
class DateConverter {
    @TypeConverter fun fromTimestamp(value: Long?): Date? = value?.let { Date(it) }
    @TypeConverter fun dateToTimestamp(date: Date?): Long? = date?.time
}
EOF

echo "  ✅ Config + models done"

# DAOs
cat > $PKG/core/data/local/dao/ExpenseDao.kt << 'EOF'
package com.financeapp.core.data.local.dao
import androidx.room.*; import com.financeapp.core.data.local.entity.ExpenseEntity; import kotlinx.coroutines.flow.Flow
@Dao
interface ExpenseDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE) suspend fun insert(e: ExpenseEntity): Long
    @Update suspend fun update(e: ExpenseEntity)
    @Delete suspend fun delete(e: ExpenseEntity)
    @Query("SELECT * FROM expenses ORDER BY date DESC") fun getAllExpenses(): Flow<List<ExpenseEntity>>
    @Query("SELECT * FROM expenses WHERE date BETWEEN :s AND :e ORDER BY date DESC") fun getByDateRange(s: Long, e: Long): Flow<List<ExpenseEntity>>
    @Query("SELECT SUM(amount) FROM expenses WHERE date BETWEEN :s AND :e") fun getTotalForPeriod(s: Long, e: Long): Flow<Double?>
    @Query("SELECT category, SUM(amount) as total FROM expenses WHERE date BETWEEN :s AND :e GROUP BY category ORDER BY total DESC") fun getCategoryTotals(s: Long, e: Long): Flow<List<CategoryTotal>>
}
data class CategoryTotal(val category: String, val total: Double)
EOF

cat > $PKG/core/data/local/dao/BudgetDao.kt << 'EOF'
package com.financeapp.core.data.local.dao
import androidx.room.*; import com.financeapp.core.data.local.entity.BudgetEntity; import kotlinx.coroutines.flow.Flow
@Dao
interface BudgetDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE) suspend fun insert(b: BudgetEntity): Long
    @Update suspend fun update(b: BudgetEntity)
    @Delete suspend fun delete(b: BudgetEntity)
    @Query("SELECT * FROM budgets WHERE month = :month AND year = :year") fun getBudgetsForMonth(month: Int, year: Int): Flow<List<BudgetEntity>>
    @Query("SELECT * FROM budgets WHERE category = :cat AND month = :month AND year = :year LIMIT 1") suspend fun getBudgetForCategory(cat: String, month: Int, year: Int): BudgetEntity?
}
EOF

cat > $PKG/core/data/local/dao/IncomeDao.kt << 'EOF'
package com.financeapp.core.data.local.dao
import androidx.room.*; import com.financeapp.core.data.local.entity.IncomeEntity; import kotlinx.coroutines.flow.Flow
@Dao
interface IncomeDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE) suspend fun insert(i: IncomeEntity): Long
    @Delete suspend fun delete(i: IncomeEntity)
    @Query("SELECT * FROM incomes ORDER BY date DESC") fun getAllIncomes(): Flow<List<IncomeEntity>>
    @Query("SELECT * FROM incomes WHERE date BETWEEN :s AND :e ORDER BY date DESC") fun getByDateRange(s: Long, e: Long): Flow<List<IncomeEntity>>
    @Query("SELECT SUM(amount) FROM incomes WHERE date BETWEEN :s AND :e") fun getTotalForPeriod(s: Long, e: Long): Flow<Double?>
}
EOF

cat > $PKG/core/data/local/dao/GoalDao.kt << 'EOF'
package com.financeapp.core.data.local.dao
import androidx.room.*; import com.financeapp.core.data.local.entity.GoalEntity; import kotlinx.coroutines.flow.Flow
@Dao
interface GoalDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE) suspend fun insert(g: GoalEntity): Long
    @Update suspend fun update(g: GoalEntity)
    @Delete suspend fun delete(g: GoalEntity)
    @Query("SELECT * FROM goals ORDER BY deadline ASC") fun getAllGoals(): Flow<List<GoalEntity>>
    @Query("SELECT * FROM goals WHERE id = :id LIMIT 1") suspend fun getById(id: Long): GoalEntity?
}
EOF

cat > $PKG/core/data/local/dao/BillDao.kt << 'EOF'
package com.financeapp.core.data.local.dao
import androidx.room.*; import com.financeapp.core.data.local.entity.BillEntity; import kotlinx.coroutines.flow.Flow
@Dao
interface BillDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE) suspend fun insert(b: BillEntity): Long
    @Update suspend fun update(b: BillEntity)
    @Delete suspend fun delete(b: BillEntity)
    @Query("SELECT * FROM bills ORDER BY dueDayOfMonth ASC") fun getAllBills(): Flow<List<BillEntity>>
    @Query("SELECT * FROM bills WHERE isPaid = 0 ORDER BY dueDayOfMonth ASC") fun getUnpaidBills(): Flow<List<BillEntity>>
    @Query("SELECT SUM(amount) FROM bills WHERE isRecurring = 1") fun getTotalMonthlyCommitments(): Flow<Double?>
}
EOF

# Database
cat > $PKG/core/data/local/database/FinanceDatabase.kt << 'EOF'
package com.financeapp.core.data.local.database
import androidx.room.Database; import androidx.room.RoomDatabase
import com.financeapp.core.data.local.dao.*
import com.financeapp.core.data.local.entity.*
@Database(entities = [ExpenseEntity::class, BudgetEntity::class, IncomeEntity::class, GoalEntity::class, BillEntity::class], version = 1, exportSchema = true)
abstract class FinanceDatabase : RoomDatabase() {
    abstract fun expenseDao(): ExpenseDao
    abstract fun budgetDao(): BudgetDao
    abstract fun incomeDao(): IncomeDao
    abstract fun goalDao(): GoalDao
    abstract fun billDao(): BillDao
    companion object { const val DATABASE_NAME = "finance_db" }
}
EOF

echo "  ✅ DAOs + Database done"

# Repository interfaces
cat > $PKG/core/domain/repository/ExpenseRepository.kt << 'EOF'
package com.financeapp.core.domain.repository
import com.financeapp.core.data.local.dao.CategoryTotal; import com.financeapp.core.domain.model.Expense; import kotlinx.coroutines.flow.Flow
interface ExpenseRepository {
    fun getAllExpenses(): Flow<List<Expense>>
    fun getExpensesByDateRange(s: Long, e: Long): Flow<List<Expense>>
    fun getTotalForPeriod(s: Long, e: Long): Flow<Double>
    fun getCategoryTotals(s: Long, e: Long): Flow<List<CategoryTotal>>
    suspend fun addExpense(expense: Expense): Long
    suspend fun updateExpense(expense: Expense)
    suspend fun deleteExpense(expense: Expense)
}
EOF
cat > $PKG/core/domain/repository/BudgetRepository.kt << 'EOF'
package com.financeapp.core.domain.repository
import com.financeapp.core.domain.model.Budget; import kotlinx.coroutines.flow.Flow
interface BudgetRepository {
    fun getBudgetsForMonth(month: Int, year: Int): Flow<List<Budget>>
    suspend fun addBudget(budget: Budget): Long
    suspend fun updateBudget(budget: Budget)
    suspend fun deleteBudget(budget: Budget)
}
EOF
cat > $PKG/core/domain/repository/IncomeRepository.kt << 'EOF'
package com.financeapp.core.domain.repository
import com.financeapp.core.domain.model.Income; import kotlinx.coroutines.flow.Flow
interface IncomeRepository {
    fun getAllIncomes(): Flow<List<Income>>
    fun getIncomesByDateRange(s: Long, e: Long): Flow<List<Income>>
    fun getTotalForPeriod(s: Long, e: Long): Flow<Double>
    suspend fun addIncome(income: Income): Long
    suspend fun deleteIncome(income: Income)
}
EOF
cat > $PKG/core/domain/repository/GoalRepository.kt << 'EOF'
package com.financeapp.core.domain.repository
import com.financeapp.core.domain.model.Goal; import kotlinx.coroutines.flow.Flow
interface GoalRepository {
    fun getAllGoals(): Flow<List<Goal>>
    suspend fun addGoal(goal: Goal): Long
    suspend fun updateGoal(goal: Goal)
    suspend fun deleteGoal(goal: Goal)
    suspend fun addToGoal(goalId: Long, amount: Double)
}
EOF
cat > $PKG/core/domain/repository/BillRepository.kt << 'EOF'
package com.financeapp.core.domain.repository
import com.financeapp.core.domain.model.Bill; import kotlinx.coroutines.flow.Flow
interface BillRepository {
    fun getAllBills(): Flow<List<Bill>>
    fun getUnpaidBills(): Flow<List<Bill>>
    fun getTotalMonthlyCommitments(): Flow<Double>
    suspend fun addBill(bill: Bill): Long
    suspend fun updateBill(bill: Bill)
    suspend fun deleteBill(bill: Bill)
    suspend fun markAsPaid(bill: Bill)
}
EOF

# Repository implementations
cat > $PKG/core/data/repository/ExpenseRepositoryImpl.kt << 'EOF'
package com.financeapp.core.data.repository
import com.financeapp.core.data.local.dao.CategoryTotal; import com.financeapp.core.data.local.dao.ExpenseDao; import com.financeapp.core.data.local.entity.ExpenseEntity
import com.financeapp.core.domain.model.Expense; import com.financeapp.core.domain.repository.ExpenseRepository
import kotlinx.coroutines.flow.map; import javax.inject.Inject
class ExpenseRepositoryImpl @Inject constructor(private val dao: ExpenseDao) : ExpenseRepository {
    override fun getAllExpenses() = dao.getAllExpenses().map { it.map { e -> e.toDomain() } }
    override fun getExpensesByDateRange(s: Long, e: Long) = dao.getByDateRange(s, e).map { it.map { x -> x.toDomain() } }
    override fun getTotalForPeriod(s: Long, e: Long) = dao.getTotalForPeriod(s, e).map { it ?: 0.0 }
    override fun getCategoryTotals(s: Long, e: Long) = dao.getCategoryTotals(s, e)
    override suspend fun addExpense(expense: Expense) = dao.insert(expense.toEntity())
    override suspend fun updateExpense(expense: Expense) = dao.update(expense.toEntity())
    override suspend fun deleteExpense(expense: Expense) = dao.delete(expense.toEntity())
    private fun ExpenseEntity.toDomain() = Expense(id, amount, category, merchant, note, date, isAutoDetected, accountLast4)
    private fun Expense.toEntity() = ExpenseEntity(id, amount, category, merchant, note, date, isAutoDetected, accountLast4)
}
EOF
cat > $PKG/core/data/repository/BudgetRepositoryImpl.kt << 'EOF'
package com.financeapp.core.data.repository
import com.financeapp.core.data.local.dao.BudgetDao; import com.financeapp.core.data.local.entity.BudgetEntity
import com.financeapp.core.domain.model.Budget; import com.financeapp.core.domain.repository.BudgetRepository
import kotlinx.coroutines.flow.map; import javax.inject.Inject
class BudgetRepositoryImpl @Inject constructor(private val dao: BudgetDao) : BudgetRepository {
    override fun getBudgetsForMonth(month: Int, year: Int) = dao.getBudgetsForMonth(month, year).map { it.map { b -> b.toDomain() } }
    override suspend fun addBudget(budget: Budget) = dao.insert(budget.toEntity())
    override suspend fun updateBudget(budget: Budget) = dao.update(budget.toEntity())
    override suspend fun deleteBudget(budget: Budget) = dao.delete(budget.toEntity())
    private fun BudgetEntity.toDomain() = Budget(id, category, limitAmount, 0.0, month, year)
    private fun Budget.toEntity() = BudgetEntity(id, category, limitAmount, month, year)
}
EOF
cat > $PKG/core/data/repository/IncomeRepositoryImpl.kt << 'EOF'
package com.financeapp.core.data.repository
import com.financeapp.core.data.local.dao.IncomeDao; import com.financeapp.core.data.local.entity.IncomeEntity
import com.financeapp.core.domain.model.Income; import com.financeapp.core.domain.repository.IncomeRepository
import kotlinx.coroutines.flow.map; import javax.inject.Inject
class IncomeRepositoryImpl @Inject constructor(private val dao: IncomeDao) : IncomeRepository {
    override fun getAllIncomes() = dao.getAllIncomes().map { it.map { i -> i.toDomain() } }
    override fun getIncomesByDateRange(s: Long, e: Long) = dao.getByDateRange(s, e).map { it.map { i -> i.toDomain() } }
    override fun getTotalForPeriod(s: Long, e: Long) = dao.getTotalForPeriod(s, e).map { it ?: 0.0 }
    override suspend fun addIncome(income: Income) = dao.insert(income.toEntity())
    override suspend fun deleteIncome(income: Income) = dao.delete(income.toEntity())
    private fun IncomeEntity.toDomain() = Income(id, amount, source, note, date, isAutoDetected)
    private fun Income.toEntity() = IncomeEntity(id, amount, source, note, date, isAutoDetected)
}
EOF
cat > $PKG/core/data/repository/GoalRepositoryImpl.kt << 'EOF'
package com.financeapp.core.data.repository
import com.financeapp.core.data.local.dao.GoalDao; import com.financeapp.core.data.local.entity.GoalEntity
import com.financeapp.core.domain.model.Goal; import com.financeapp.core.domain.repository.GoalRepository
import kotlinx.coroutines.flow.map; import javax.inject.Inject
class GoalRepositoryImpl @Inject constructor(private val dao: GoalDao) : GoalRepository {
    override fun getAllGoals() = dao.getAllGoals().map { it.map { g -> g.toDomain() } }
    override suspend fun addGoal(goal: Goal) = dao.insert(goal.toEntity())
    override suspend fun updateGoal(goal: Goal) = dao.update(goal.toEntity())
    override suspend fun deleteGoal(goal: Goal) = dao.delete(goal.toEntity())
    override suspend fun addToGoal(goalId: Long, amount: Double) {
        val entity = dao.getById(goalId) ?: return
        dao.update(entity.copy(savedAmount = entity.savedAmount + amount))
    }
    private fun GoalEntity.toDomain() = Goal(id, name, targetAmount, savedAmount, deadline, emoji)
    private fun Goal.toEntity() = GoalEntity(id, name, targetAmount, savedAmount, deadline, emoji)
}
EOF
cat > $PKG/core/data/repository/BillRepositoryImpl.kt << 'EOF'
package com.financeapp.core.data.repository
import com.financeapp.core.data.local.dao.BillDao; import com.financeapp.core.data.local.entity.BillEntity
import com.financeapp.core.domain.model.Bill; import com.financeapp.core.domain.repository.BillRepository
import kotlinx.coroutines.flow.map; import javax.inject.Inject
class BillRepositoryImpl @Inject constructor(private val dao: BillDao) : BillRepository {
    override fun getAllBills() = dao.getAllBills().map { it.map { b -> b.toDomain() } }
    override fun getUnpaidBills() = dao.getUnpaidBills().map { it.map { b -> b.toDomain() } }
    override fun getTotalMonthlyCommitments() = dao.getTotalMonthlyCommitments().map { it ?: 0.0 }
    override suspend fun addBill(bill: Bill) = dao.insert(bill.toEntity())
    override suspend fun updateBill(bill: Bill) = dao.update(bill.toEntity())
    override suspend fun deleteBill(bill: Bill) = dao.delete(bill.toEntity())
    override suspend fun markAsPaid(bill: Bill) = dao.update(bill.toEntity().copy(isPaid = true))
    private fun BillEntity.toDomain() = Bill(id, name, amount, dueDayOfMonth, category, isRecurring, isPaid)
    private fun Bill.toEntity() = BillEntity(id, name, amount, dueDayOfMonth, category, isRecurring, isPaid)
}
EOF

echo "  ✅ Repositories done"

# Use Cases
cat > $PKG/core/domain/usecase/expense/AddExpenseUseCase.kt << 'EOF'
package com.financeapp.core.domain.usecase.expense
import com.financeapp.core.domain.model.Expense; import com.financeapp.core.domain.repository.ExpenseRepository; import javax.inject.Inject
class AddExpenseUseCase @Inject constructor(private val repo: ExpenseRepository) {
    suspend operator fun invoke(expense: Expense): Result<Long> = runCatching {
        require(expense.amount > 0) { "Amount must be greater than zero" }
        require(expense.category.isNotBlank()) { "Category cannot be empty" }
        require(expense.merchant.isNotBlank()) { "Merchant cannot be empty" }
        repo.addExpense(expense)
    }
}
EOF
cat > $PKG/core/domain/usecase/expense/GetExpensesUseCase.kt << 'EOF'
package com.financeapp.core.domain.usecase.expense
import com.financeapp.core.domain.repository.ExpenseRepository; import javax.inject.Inject
class GetExpensesUseCase @Inject constructor(private val repo: ExpenseRepository) {
    operator fun invoke(s: Long, e: Long) = repo.getExpensesByDateRange(s, e)
}
EOF
cat > $PKG/core/domain/usecase/expense/DeleteExpenseUseCase.kt << 'EOF'
package com.financeapp.core.domain.usecase.expense
import com.financeapp.core.domain.model.Expense; import com.financeapp.core.domain.repository.ExpenseRepository; import javax.inject.Inject
class DeleteExpenseUseCase @Inject constructor(private val repo: ExpenseRepository) {
    suspend operator fun invoke(expense: Expense) = repo.deleteExpense(expense)
}
EOF
cat > $PKG/core/domain/usecase/expense/GetCategoryTotalsUseCase.kt << 'EOF'
package com.financeapp.core.domain.usecase.expense
import com.financeapp.core.domain.repository.ExpenseRepository; import javax.inject.Inject
class GetCategoryTotalsUseCase @Inject constructor(private val repo: ExpenseRepository) {
    operator fun invoke(s: Long, e: Long) = repo.getCategoryTotals(s, e)
}
EOF
cat > $PKG/core/domain/usecase/budget/AddBudgetUseCase.kt << 'EOF'
package com.financeapp.core.domain.usecase.budget
import com.financeapp.core.domain.model.Budget; import com.financeapp.core.domain.repository.BudgetRepository; import javax.inject.Inject
class AddBudgetUseCase @Inject constructor(private val repo: BudgetRepository) {
    suspend operator fun invoke(budget: Budget): Result<Long> = runCatching {
        require(budget.limitAmount > 0) { "Budget limit must be greater than zero" }
        require(budget.category.isNotBlank()) { "Category cannot be empty" }
        repo.addBudget(budget)
    }
}
EOF
cat > $PKG/core/domain/usecase/budget/GetBudgetStatusUseCase.kt << 'EOF'
package com.financeapp.core.domain.usecase.budget
import com.financeapp.core.domain.model.Budget; import com.financeapp.core.domain.repository.BudgetRepository; import kotlinx.coroutines.flow.Flow; import java.util.Calendar; import javax.inject.Inject
class GetBudgetStatusUseCase @Inject constructor(private val repo: BudgetRepository) {
    operator fun invoke(): Flow<List<Budget>> {
        val cal = Calendar.getInstance()
        return repo.getBudgetsForMonth(cal.get(Calendar.MONTH) + 1, cal.get(Calendar.YEAR))
    }
}
EOF
cat > $PKG/core/domain/usecase/income/AddIncomeUseCase.kt << 'EOF'
package com.financeapp.core.domain.usecase.income
import com.financeapp.core.domain.model.Income; import com.financeapp.core.domain.repository.IncomeRepository; import javax.inject.Inject
class AddIncomeUseCase @Inject constructor(private val repo: IncomeRepository) {
    suspend operator fun invoke(income: Income): Result<Long> = runCatching {
        require(income.amount > 0) { "Amount must be greater than zero" }
        require(income.source.isNotBlank()) { "Source cannot be empty" }
        repo.addIncome(income)
    }
}
EOF
cat > $PKG/core/domain/usecase/income/GetIncomesUseCase.kt << 'EOF'
package com.financeapp.core.domain.usecase.income
import com.financeapp.core.domain.repository.IncomeRepository; import javax.inject.Inject
class GetIncomesUseCase @Inject constructor(private val repo: IncomeRepository) {
    operator fun invoke(s: Long, e: Long) = repo.getIncomesByDateRange(s, e)
}
EOF
cat > $PKG/core/domain/usecase/goal/AddGoalUseCase.kt << 'EOF'
package com.financeapp.core.domain.usecase.goal
import com.financeapp.core.domain.model.Goal; import com.financeapp.core.domain.repository.GoalRepository; import javax.inject.Inject
class AddGoalUseCase @Inject constructor(private val repo: GoalRepository) {
    suspend operator fun invoke(goal: Goal): Result<Long> = runCatching {
        require(goal.targetAmount > 0) { "Target must be greater than zero" }
        require(goal.name.isNotBlank()) { "Name cannot be empty" }
        repo.addGoal(goal)
    }
}
EOF
cat > $PKG/core/domain/usecase/goal/GetGoalsUseCase.kt << 'EOF'
package com.financeapp.core.domain.usecase.goal
import com.financeapp.core.domain.repository.GoalRepository; import javax.inject.Inject
class GetGoalsUseCase @Inject constructor(private val repo: GoalRepository) {
    operator fun invoke() = repo.getAllGoals()
}
EOF
cat > $PKG/core/domain/usecase/bill/AddBillUseCase.kt << 'EOF'
package com.financeapp.core.domain.usecase.bill
import com.financeapp.core.domain.model.Bill; import com.financeapp.core.domain.repository.BillRepository; import javax.inject.Inject
class AddBillUseCase @Inject constructor(private val repo: BillRepository) {
    suspend operator fun invoke(bill: Bill): Result<Long> = runCatching {
        require(bill.amount > 0) { "Amount must be greater than zero" }
        require(bill.name.isNotBlank()) { "Bill name cannot be empty" }
        repo.addBill(bill)
    }
}
EOF
cat > $PKG/core/domain/usecase/bill/GetBillsUseCase.kt << 'EOF'
package com.financeapp.core.domain.usecase.bill
import com.financeapp.core.domain.repository.BillRepository; import javax.inject.Inject
class GetBillsUseCase @Inject constructor(private val repo: BillRepository) {
    operator fun invoke() = repo.getAllBills()
}
EOF

echo "  ✅ Use cases done"

# DI Modules
cat > $PKG/di/DatabaseModule.kt << 'EOF'
package com.financeapp.di
import android.content.Context; import androidx.room.Room; import com.financeapp.core.data.local.dao.*; import com.financeapp.core.data.local.database.FinanceDatabase
import dagger.Module; import dagger.Provides; import dagger.hilt.InstallIn; import dagger.hilt.android.qualifiers.ApplicationContext; import dagger.hilt.components.SingletonComponent; import javax.inject.Singleton
@Module @InstallIn(SingletonComponent::class)
object DatabaseModule {
    @Provides @Singleton
    fun provideDatabase(@ApplicationContext context: Context): FinanceDatabase =
        Room.databaseBuilder(context, FinanceDatabase::class.java, FinanceDatabase.DATABASE_NAME).fallbackToDestructiveMigration().build()
    @Provides fun provideExpenseDao(db: FinanceDatabase): ExpenseDao = db.expenseDao()
    @Provides fun provideBudgetDao(db: FinanceDatabase): BudgetDao   = db.budgetDao()
    @Provides fun provideIncomeDao(db: FinanceDatabase): IncomeDao   = db.incomeDao()
    @Provides fun provideGoalDao(db: FinanceDatabase): GoalDao       = db.goalDao()
    @Provides fun provideBillDao(db: FinanceDatabase): BillDao       = db.billDao()
}
EOF

cat > $PKG/di/RepositoryModule.kt << 'EOF'
package com.financeapp.di
import com.financeapp.core.data.repository.*; import com.financeapp.core.domain.repository.*
import dagger.Binds; import dagger.Module; import dagger.hilt.InstallIn; import dagger.hilt.components.SingletonComponent; import javax.inject.Singleton
@Module @InstallIn(SingletonComponent::class)
abstract class RepositoryModule {
    @Binds @Singleton abstract fun bindExpenseRepository(impl: ExpenseRepositoryImpl): ExpenseRepository
    @Binds @Singleton abstract fun bindBudgetRepository(impl: BudgetRepositoryImpl): BudgetRepository
    @Binds @Singleton abstract fun bindIncomeRepository(impl: IncomeRepositoryImpl): IncomeRepository
    @Binds @Singleton abstract fun bindGoalRepository(impl: GoalRepositoryImpl): GoalRepository
    @Binds @Singleton abstract fun bindBillRepository(impl: BillRepositoryImpl): BillRepository
}
EOF

cat > $PKG/di/UseCaseModule.kt << 'EOF'
package com.financeapp.di
import com.financeapp.core.domain.repository.*; import com.financeapp.core.domain.usecase.expense.*; import com.financeapp.core.domain.usecase.budget.*
import com.financeapp.core.domain.usecase.income.*; import com.financeapp.core.domain.usecase.goal.*; import com.financeapp.core.domain.usecase.bill.*
import dagger.Module; import dagger.Provides; import dagger.hilt.InstallIn; import dagger.hilt.components.SingletonComponent
@Module @InstallIn(SingletonComponent::class)
object UseCaseModule {
    @Provides fun provideAddExpenseUseCase(r: ExpenseRepository)       = AddExpenseUseCase(r)
    @Provides fun provideGetExpensesUseCase(r: ExpenseRepository)      = GetExpensesUseCase(r)
    @Provides fun provideDeleteExpenseUseCase(r: ExpenseRepository)    = DeleteExpenseUseCase(r)
    @Provides fun provideGetCategoryTotalsUseCase(r: ExpenseRepository)= GetCategoryTotalsUseCase(r)
    @Provides fun provideAddBudgetUseCase(r: BudgetRepository)         = AddBudgetUseCase(r)
    @Provides fun provideGetBudgetStatusUseCase(r: BudgetRepository)   = GetBudgetStatusUseCase(r)
    @Provides fun provideAddIncomeUseCase(r: IncomeRepository)         = AddIncomeUseCase(r)
    @Provides fun provideGetIncomesUseCase(r: IncomeRepository)        = GetIncomesUseCase(r)
    @Provides fun provideAddGoalUseCase(r: GoalRepository)             = AddGoalUseCase(r)
    @Provides fun provideGetGoalsUseCase(r: GoalRepository)            = GetGoalsUseCase(r)
    @Provides fun provideAddBillUseCase(r: BillRepository)             = AddBillUseCase(r)
    @Provides fun provideGetBillsUseCase(r: BillRepository)            = GetBillsUseCase(r)
}
EOF

# Utils
cat > $PKG/core/utils/DateUtils.kt << 'EOF'
package com.financeapp.core.utils
import java.text.SimpleDateFormat; import java.util.*
object DateUtils {
    fun currentMonthRange(): Pair<Long, Long> {
        val cal = Calendar.getInstance()
        cal.set(Calendar.DAY_OF_MONTH, 1); cal.set(Calendar.HOUR_OF_DAY, 0); cal.set(Calendar.MINUTE, 0); cal.set(Calendar.SECOND, 0); cal.set(Calendar.MILLISECOND, 0)
        val start = cal.timeInMillis
        cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH)); cal.set(Calendar.HOUR_OF_DAY, 23); cal.set(Calendar.MINUTE, 59); cal.set(Calendar.SECOND, 59)
        return Pair(start, cal.timeInMillis)
    }
    fun formatDate(ts: Long, pattern: String = "dd MMM yyyy"): String = SimpleDateFormat(pattern, Locale.getDefault()).format(Date(ts))
    fun formatDateTime(ts: Long): String = SimpleDateFormat("dd MMM, hh:mm a", Locale.getDefault()).format(Date(ts))
    fun monthYearLabel(ts: Long = System.currentTimeMillis()): String = SimpleDateFormat("MMMM yyyy", Locale.getDefault()).format(Date(ts))
}
EOF
cat > $PKG/core/utils/CurrencyUtils.kt << 'EOF'
package com.financeapp.core.utils
import java.text.NumberFormat; import java.util.Locale
object CurrencyUtils {
    private val inrFormat = NumberFormat.getCurrencyInstance(Locale("en", "IN"))
    fun formatINR(amount: Double): String = inrFormat.format(amount)
    fun formatCompact(amount: Double): String = when {
        amount >= 100_000 -> "₹${"%.1f".format(amount / 100_000)}L"
        amount >= 1_000   -> "₹${"%.1f".format(amount / 1_000)}K"
        else              -> "₹${"%.0f".format(amount)}"
    }
}
EOF
cat > $PKG/core/utils/Constants.kt << 'EOF'
package com.financeapp.core.utils
object Constants {
    val EXPENSE_CATEGORIES = listOf("Food","Groceries","Transport","Entertainment","Shopping","Health","Utilities","EMI / Loans","Insurance","Education","Travel","Others")
    val INCOME_SOURCES = listOf("Salary","Freelance","Business","Rental","Investment","Gift","Refund","Others")
}
EOF

echo "  ✅ DI + Utils done"

# SMS
cat > $PKG/sms/parser/UpiSmsPatterns.kt << 'EOF'
package com.financeapp.sms.parser
object UpiSmsPatterns {
    val BANK_SENDERS = setOf("HDFCBK","ICICIB","SBIINB","AXISBK","KOTAKB","INDBNK","PNBSMS","BOIIND","CANBNK","CENTBK","IDBIBNK","YESBNK","FEDBK","IDFCFB","PAYTM","PHONEPE","GPAY")
    val DEBIT_PATTERNS = listOf(
        Regex("""(?:Rs\.?|INR\s?)([0-9,]+\.?\d*)\s+debited.*?(?:UPI[:\s]+|Info[:\s]+|Merchant[:\s]+)([A-Za-z0-9 &._\-]+)""", RegexOption.IGNORE_CASE),
        Regex("""debited\s+with\s+(?:INR|Rs\.?)\s*([0-9,]+\.?\d*).*?(?:Info[:\s]+|UPI[:\s]+|Merchant[:\s]+)([A-Za-z0-9 &._\-]+)""", RegexOption.IGNORE_CASE),
        Regex("""(?:Rs\.?|INR)\s+([0-9,]+\.?\d*)\s+debited.*?(?:Merchant[:\s]+|at\s+)([A-Za-z0-9 &._\-]+)""", RegexOption.IGNORE_CASE),
        Regex("""sent\s+(?:Rs\.?|INR)\s*([0-9,]+\.?\d*)\s+to\s+([A-Za-z0-9 &._\-]+)\s+via""", RegexOption.IGNORE_CASE),
        Regex("""(?:Rs\.?|INR)\s*([0-9,]+\.?\d*)\s+paid\s+to\s+([A-Za-z0-9 &._\-]+)""", RegexOption.IGNORE_CASE)
    )
    val CREDIT_PATTERNS = listOf(
        Regex("""(?:Rs\.?|INR\s?)([0-9,]+\.?\d*)\s+credited.*?(?:from[:\s]+|by[:\s]+)([A-Za-z0-9 &._\-]+)""", RegexOption.IGNORE_CASE),
        Regex("""credited\s+with\s+(?:INR|Rs\.?)\s*([0-9,]+\.?\d*).*?(?:from[:\s]+)([A-Za-z0-9 &._\-]+)""", RegexOption.IGNORE_CASE),
        Regex("""received\s+(?:Rs\.?|INR)\s*([0-9,]+\.?\d*)\s+from\s+([A-Za-z0-9 &._\-]+)""", RegexOption.IGNORE_CASE)
    )
    val ACCOUNT_PATTERN = Regex("""(?:A/c|a/c|ac|account)\s*[A-Z]{0,4}(\d{4})""", RegexOption.IGNORE_CASE)
    private val CATEGORY_MAP = mapOf(
        "swiggy" to "Food","zomato" to "Food","dominos" to "Food","mcdonald" to "Food","kfc" to "Food",
        "blinkit" to "Groceries","bigbasket" to "Groceries","zepto" to "Groceries","dmart" to "Groceries",
        "uber" to "Transport","ola" to "Transport","rapido" to "Transport","irctc" to "Transport","petrol" to "Transport",
        "netflix" to "Entertainment","spotify" to "Entertainment","prime" to "Entertainment","hotstar" to "Entertainment",
        "amazon" to "Shopping","flipkart" to "Shopping","myntra" to "Shopping","meesho" to "Shopping",
        "pharmacy" to "Health","apollo" to "Health","medplus" to "Health","practo" to "Health","1mg" to "Health",
        "electricity" to "Utilities","airtel" to "Utilities","jio" to "Utilities","bsnl" to "Utilities",
        "emi" to "EMI / Loans","loan" to "EMI / Loans","lic" to "Insurance",
        "makemytrip" to "Travel","goibibo" to "Travel","cleartrip" to "Travel"
    )
    fun inferCategory(merchant: String): String = CATEGORY_MAP.entries.firstOrNull { merchant.lowercase().contains(it.key) }?.value ?: "Others"
}
EOF

cat > $PKG/sms/parser/SmsParser.kt << 'EOF'
package com.financeapp.sms.parser
import com.financeapp.core.domain.model.Expense; import com.financeapp.core.domain.model.Income
enum class SmsType { DEBIT, CREDIT, UNKNOWN }
data class ParsedSms(val type: SmsType, val amount: Double, val party: String, val accountLast4: String, val category: String)
object SmsParser {
    fun parse(sender: String, body: String): ParsedSms? {
        if (UpiSmsPatterns.BANK_SENDERS.none { sender.uppercase().contains(it) }) return null
        for (p in UpiSmsPatterns.DEBIT_PATTERNS) {
            val m = p.find(body) ?: continue
            val amount = m.groupValues[1].replace(",","").toDoubleOrNull() ?: continue
            val merchant = m.groupValues[2].trim().take(40)
            val account = UpiSmsPatterns.ACCOUNT_PATTERN.find(body)?.groupValues?.get(1) ?: ""
            return ParsedSms(SmsType.DEBIT, amount, merchant, account, UpiSmsPatterns.inferCategory(merchant))
        }
        for (p in UpiSmsPatterns.CREDIT_PATTERNS) {
            val m = p.find(body) ?: continue
            val amount = m.groupValues[1].replace(",","").toDoubleOrNull() ?: continue
            val source = m.groupValues[2].trim().take(40)
            val account = UpiSmsPatterns.ACCOUNT_PATTERN.find(body)?.groupValues?.get(1) ?: ""
            return ParsedSms(SmsType.CREDIT, amount, source, account, "Income")
        }
        return null
    }
    fun toExpense(p: ParsedSms) = Expense(amount = p.amount, category = p.category, merchant = p.party, note = "Auto-detected via UPI SMS", date = System.currentTimeMillis(), isAutoDetected = true, accountLast4 = p.accountLast4)
    fun toIncome(p: ParsedSms) = Income(amount = p.amount, source = p.party, note = "Auto-detected via UPI SMS", date = System.currentTimeMillis(), isAutoDetected = true)
}
EOF

cat > $PKG/sms/receiver/SmsReceiver.kt << 'EOF'
package com.financeapp.sms.receiver
import android.content.BroadcastReceiver; import android.content.Context; import android.content.Intent; import android.provider.Telephony
import com.financeapp.core.domain.usecase.expense.AddExpenseUseCase; import com.financeapp.core.domain.usecase.income.AddIncomeUseCase
import com.financeapp.sms.parser.SmsParser; import com.financeapp.sms.parser.SmsType
import dagger.hilt.android.AndroidEntryPoint; import kotlinx.coroutines.CoroutineScope; import kotlinx.coroutines.Dispatchers; import kotlinx.coroutines.launch; import javax.inject.Inject
@AndroidEntryPoint
class SmsReceiver : BroadcastReceiver() {
    @Inject lateinit var addExpenseUseCase: AddExpenseUseCase
    @Inject lateinit var addIncomeUseCase: AddIncomeUseCase
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Telephony.Sms.Intents.SMS_RECEIVED_ACTION) return
        val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)
        for (sms in messages) {
            val parsed = SmsParser.parse(sms.originatingAddress ?: continue, sms.messageBody ?: continue) ?: continue
            CoroutineScope(Dispatchers.IO).launch {
                when (parsed.type) {
                    SmsType.DEBIT  -> addExpenseUseCase(SmsParser.toExpense(parsed))
                    SmsType.CREDIT -> addIncomeUseCase(SmsParser.toIncome(parsed))
                    else           -> Unit
                }
            }
        }
    }
}
EOF

# ViewModels
cat > $PKG/feature/dashboard/viewmodel/DashboardViewModel.kt << 'EOF'
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
EOF

cat > $PKG/feature/expenses/viewmodel/ExpenseViewModel.kt << 'EOF'
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
EOF

cat > $PKG/feature/budget/viewmodel/BudgetViewModel.kt << 'EOF'
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
EOF

cat > $PKG/feature/goals/viewmodel/GoalsViewModel.kt << 'EOF'
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
EOF

# Stub ViewModels
for vm in "income:IncomeViewModel" "reports:ReportsViewModel" "bills:BillsViewModel" "settings:SettingsViewModel"; do
  pkg="${vm%%:*}"; name="${vm##*:}"
  cat > $PKG/feature/${pkg}/viewmodel/${name}.kt << VMEOF
package com.financeapp.feature.${pkg}.viewmodel
import androidx.lifecycle.ViewModel; import dagger.hilt.android.lifecycle.HiltViewModel; import javax.inject.Inject
@HiltViewModel
class ${name} @Inject constructor() : ViewModel()
VMEOF
done

# Screen stubs
write_screen() {
  local file="$1" pkg="$2" name="$3" vmImport="$4" vm="$5"
  if [ -n "$vmImport" ]; then
    cat > "$file" << SCREENEOF
package $pkg
import androidx.compose.foundation.layout.*; import androidx.compose.material3.*; import androidx.compose.runtime.*; import androidx.compose.ui.Modifier; import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel; import androidx.navigation.NavController; import $vmImport
@Composable
fun ${name}(navController: NavController, viewModel: ${vm} = hiltViewModel()) {
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text("${name}", style = MaterialTheme.typography.headlineMedium)
        Spacer(Modifier.height(8.dp))
        Text("Coming soon — wire up viewModel.uiState here", style = MaterialTheme.typography.bodyMedium)
    }
}
SCREENEOF
  else
    cat > "$file" << SCREENEOF
package $pkg
import androidx.compose.foundation.layout.*; import androidx.compose.material3.*; import androidx.compose.runtime.Composable; import androidx.compose.ui.Modifier; import androidx.compose.ui.unit.dp; import androidx.navigation.NavController
@Composable
fun ${name}(navController: NavController) {
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) { Text("${name}", style = MaterialTheme.typography.headlineMedium) }
}
SCREENEOF
  fi
}

write_screen "$PKG/feature/dashboard/ui/DashboardScreen.kt"  "com.financeapp.feature.dashboard.ui"  "DashboardScreen"   "com.financeapp.feature.dashboard.viewmodel.DashboardViewModel"  "DashboardViewModel"
write_screen "$PKG/feature/expenses/ui/ExpenseListScreen.kt"  "com.financeapp.feature.expenses.ui"   "ExpenseListScreen"  "com.financeapp.feature.expenses.viewmodel.ExpenseViewModel"      "ExpenseViewModel"
write_screen "$PKG/feature/expenses/ui/AddExpenseScreen.kt"   "com.financeapp.feature.expenses.ui"   "AddExpenseScreen"   "com.financeapp.feature.expenses.viewmodel.ExpenseViewModel"      "ExpenseViewModel"
write_screen "$PKG/feature/budget/ui/BudgetScreen.kt"         "com.financeapp.feature.budget.ui"     "BudgetScreen"       "com.financeapp.feature.budget.viewmodel.BudgetViewModel"          "BudgetViewModel"
write_screen "$PKG/feature/goals/ui/GoalsScreen.kt"           "com.financeapp.feature.goals.ui"      "GoalsScreen"        "com.financeapp.feature.goals.viewmodel.GoalsViewModel"            "GoalsViewModel"
write_screen "$PKG/feature/income/ui/IncomeScreen.kt"         "com.financeapp.feature.income.ui"     "IncomeScreen"       "" ""
write_screen "$PKG/feature/reports/ui/ReportsScreen.kt"       "com.financeapp.feature.reports.ui"    "ReportsScreen"      "" ""
write_screen "$PKG/feature/bills/ui/BillsScreen.kt"           "com.financeapp.feature.bills.ui"      "BillsScreen"        "" ""
write_screen "$PKG/feature/settings/ui/SettingsScreen.kt"     "com.financeapp.feature.settings.ui"   "SettingsScreen"     "" ""

# Unit tests
cat > app/src/test/java/com/financeapp/sms/SmsParserTest.kt << 'EOF'
package com.financeapp.sms
import com.financeapp.sms.parser.SmsParser; import com.financeapp.sms.parser.SmsType
import org.junit.Assert.*; import org.junit.Test
class SmsParserTest {
    @Test fun `parses HDFC debit SMS`() {
        val r = SmsParser.parse("HDFCBK", "Rs.450.00 debited from A/c XX1234 on 20-03-26. UPI:Swiggy. Avl Bal:Rs.12,340.")
        assertNotNull(r); assertEquals(SmsType.DEBIT, r!!.type); assertEquals(450.0, r.amount, 0.01); assertEquals("Food", r.category)
    }
    @Test fun `ignores non-bank SMS`() { assertNull(SmsParser.parse("AMAZON", "Your order shipped")) }
    @Test fun `parses credit SMS`() {
        val r = SmsParser.parse("SBIINB", "Rs.50000.00 credited to A/c XX5678. Info: from EMPLOYER LTD.")
        assertNotNull(r); assertEquals(SmsType.CREDIT, r!!.type); assertEquals(50000.0, r.amount, 0.01)
    }
}
EOF

echo ""
echo "✅ ALL FILES CREATED SUCCESSFULLY!"
echo "Total files: $(find . -type f -name '*.kt' -o -name '*.kts' -o -name '*.xml' -o -name '*.toml' -o -name '*.properties' | wc -l)"
echo ""
echo "👉 Next: chmod +x gradlew && ./gradlew assembleDebug"