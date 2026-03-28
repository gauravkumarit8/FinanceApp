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
