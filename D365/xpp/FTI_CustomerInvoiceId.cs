/// <summary>
/// saves the invoice id to use
/// </summary>
[ExtensionOf(classStr(NumberSeq))]
public final class SS_NumberSeq_Extension
{
    private InvoiceId SS_InvoiceIdToUse;

    /// <summary>
    /// If invoiceId is to be set as opposed to a number sequence
    /// </summary>
    /// <param name = "_SSInvoiceIdToUse">InvoiceId to use</param>
    /// <returns>InvoiceId to use</returns>
    public InvoiceId parmSSInvoiceIdToUse(InvoiceId _SSInvoiceIdToUse)
    {
        SS_InvoiceIdToUse = _SSInvoiceIdToUse;
        return SS_InvoiceIdToUse;
    }

    ///<summary>
    /// Override num and voucher. Will send the invoiceId To use instead of the number sequence. Voucher is still from Number seq
    ///</summary>
    ///<returns>invoiceId,voucher as container</returns>
    public container numAndVoucher()
    {
        Num                     lastNumGenerated;
        Voucher                 lastVoucherNumGenerated;

        container result = next numAndVoucher();

        if(SS_InvoiceIdToUse)
        {
            [lastNumGenerated,lastVoucherNumGenerated] = result;

            result = [SS_InvoiceIdToUse, lastVoucherNumGenerated];
        }
        return result;
    }
}

/// <summary>
/// populate the invoiceId to use
/// </summary>
[ExtensionOf(classStr(CustPostInvoice))]
public final class SS_CustPostInvoice_Extension
{
    /// <summary>
    ///
    /// </summary>
    /// <param name = "_creditNote"></param>
    /// <returns></returns>
    NumberSeq allocateNumAndVoucher(boolean _creditNote)
    {
        NumberSeq locNumberSeq = next allocateNumAndVoucher(_creditNote);

        if(this.custInvoiceTable.MYINVOICEID) // can also use InvoiceId field
        {
            locNumberSeq.parmSSInvoiceIdToUse(this.custInvoiceTable.MYINVOICEID);
        }

        return locNumberSeq;
    }

}
