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
