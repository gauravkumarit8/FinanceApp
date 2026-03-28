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
