// codeunit 50111 "Liquidity Report Mgt."
// {
//     procedure PopulateLiquidityMetrics(AsOfDate: Date)
//     var
//         LiquidityMetric: Record "Liquidity Metric";
//     begin
//         LiquidityMetric.SetRange("Date", AsOfDate);
//         if LiquidityMetric.HasFilter() then
//             LiquidityMetric.DeleteAll();

//         InsertLiquidityMetric(Enum::"Liquidity Metric Type"::"Cash at Bank", GetCashAtBank(AsOfDate), AsOfDate);
//         InsertLiquidityMetric(Enum::"Liquidity Metric Type"::"Cash on Hand", GetCashOnHand(AsOfDate), AsOfDate);
//         InsertLiquidityMetric(Enum::"Liquidity Metric Type"::"Total Liquid Assets", GetTotalLiquidAssets(AsOfDate), AsOfDate);
//         InsertLiquidityMetric(Enum::"Liquidity Metric Type"::"Expected Loan Disbursements", GetExpectedLoanDisbursements(AsOfDate), AsOfDate);
//         InsertLiquidityMetric(Enum::"Liquidity Metric Type"::"Expected Collections Today", GetExpectedCollectionsToday(AsOfDate), AsOfDate);
//         InsertLiquidityMetric(Enum::"Liquidity Metric Type"::"Net Liquidity Position", GetNetLiquidityPosition(AsOfDate), AsOfDate);
//         InsertLiquidityMetric(Enum::"Liquidity Metric Type"::"Liquidity Ratio", GetLiquidityRatio(AsOfDate), AsOfDate);
//     end;

//     procedure PopulateCashFlowForecast(FromDate: Date; ToDate: Date)
//     var
//         CashFlowEntry: Record "Cash Flow Forecast Entry";
//     begin
//         CashFlowEntry.SetRange("Date", FromDate, ToDate);
//         if CashFlowEntry.HasFilter() then
//             CashFlowEntry.DeleteAll();

//         InsertCashFlowEntry(Enum::"Cash Flow Period Type"::Today, GetInflows(FromDate, FromDate), GetOutflows(FromDate, FromDate), FromDate);
//         InsertCashFlowEntry(Enum::"Cash Flow Period Type"::"7 Days", GetInflows(FromDate, FromDate + 7), GetOutflows(FromDate, FromDate + 7), FromDate);
//         InsertCashFlowEntry(Enum::"Cash Flow Period Type"::"30 Days", GetInflows(FromDate, ToDate), GetOutflows(FromDate, ToDate), FromDate);
//     end;

//     local procedure InsertLiquidityMetric(MetricType: Enum "Liquidity Metric Type"; Amount: Decimal; EntryDate: Date)
//     var
//         LiquidityMetric: Record "Liquidity Metric";
//     begin
//         LiquidityMetric.Init();
//         LiquidityMetric.Metric := MetricType;
//         LiquidityMetric.Amount := Amount;
//         LiquidityMetric."Date" := EntryDate;
//         LiquidityMetric.Insert(true);
//     end;

//     local procedure InsertCashFlowEntry(PeriodType: Enum "Cash Flow Period Type"; Inflows: Decimal; Outflows: Decimal; EntryDate: Date)
//     var
//         CashFlowEntry: Record "Cash Flow Forecast Entry";
//     begin
//         CashFlowEntry.Init();
//         CashFlowEntry.Period := PeriodType;
//         CashFlowEntry.Inflows := Inflows;
//         CashFlowEntry.Outflows := Outflows;
//         CashFlowEntry."Date" := EntryDate;
//         CashFlowEntry.Insert(true);
//     end;

//     local procedure GetCashAtBank(AsOfDate: Date): Decimal
//     var
//         BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
//     begin
//         BankAccountLedgerEntry.SetRange("Posting Date", 0D, AsOfDate);
//         BankAccountLedgerEntry.CalcSums("Amount");
//         exit(BankAccountLedgerEntry."Amount");
//     end;

//     local procedure GetInflows(FromDate: Date; ToDate: Date): Decimal
//     var
//         GLEntry: Record "G/L Entry";
//     begin
//         GLEntry.SetRange("Posting Date", FromDate, ToDate);
//         GLEntry.SetFilter("Debit Amount", '>0');
//         GLEntry.CalcSums("Debit Amount");
//         exit(GLEntry."Debit Amount");
//     end;

//     local procedure GetTotalLiquidAssets(AsOfDate: Date): Decimal
//     begin
//         exit(GetCashAtBank(AsOfDate) + GetCashOnHand(AsOfDate));
//     end;

//     local procedure GetExpectedLoanDisbursements(AsOfDate: Date): Decimal
//     var
//         LoanDisbursement: Record "Loan Disbursement";
//         Total: Decimal;
//     begin
//         Total := 0;
//         LoanDisbursement.SetRange("Posting Date", AsOfDate);
//         LoanDisbursement.SetRange("Status", LoanDisbursement.Status::Pending);
//         if LoanDisbursement.FindSet() then
//             repeat
//                 Total += LoanDisbursement.Amount;
//             until LoanDisbursement.Next() = 0;
//         exit(Total);
//     end;

//     local procedure GetExpectedCollectionsToday(AsOfDate: Date): Decimal
//     begin
//         exit(0);
//     end;

//     local procedure GetNetLiquidityPosition(AsOfDate: Date): Decimal
//     begin
//         exit(GetTotalLiquidAssets(AsOfDate) + GetExpectedLoanDisbursements(AsOfDate) + GetExpectedCollectionsToday(AsOfDate));
//     end;

//     local procedure GetLiquidityRatio(AsOfDate: Date): Decimal
//     begin
//         if GetTotalLiquidAssets(AsOfDate) = 0 then
//             exit(0);
//         if GetNetLiquidityPosition(AsOfDate) = 0 then
//             exit(0);
//         exit(GetTotalLiquidAssets(AsOfDate) / abs(GetNetLiquidityPosition(AsOfDate)));
//     end;

//     local procedure GetInflows(FromDate: Date; ToDate: Date): Decimal
//     begin
//         exit(0);
//     end;

//     local procedure GetOutflows(FromDate: Date; ToDate: Date): Decimal
//     var
//         GLEntry: Record "G/L Entry";
//     begin
//         GLEntry.SetRange("Posting Date", FromDate, ToDate);
//         GLEntry.SetFilter("Credit Amount", '>0');
//         GLEntry.CalcSums("Credit Amount");
//         exit(GLEntry."Credit Amount");
//     end;

//     local procedure GetTotalFromBankAccountDetail(AsOfDate: Date): Decimal
//     var
//         BankAccountDetail: Record "Bank Account Detail";
//         Total: Decimal;
//     begin
//         Total := 0;
//         BankAccountDetail.SetRange("As Of Date", AsOfDate);
//         if BankAccountDetail.FindSet() then
//             repeat
//                 Total += BankAccountDetail.Balance;
//             until BankAccountDetail.Next() = 0;
//         exit(Total);
//     end;
// }


codeunit 50111 "Liquidity Report Mgt."
{
    procedure PopulateLiquidityMetrics(AsOfDate: Date)
    var
        LiquidityMetric: Record "Liquidity Metric";
    begin
        // Remove only the BOSA liquidity metrics for this date.
        // This does NOT touch Microsoft's Cash Flow Forecast Entry table.
        LiquidityMetric.SetRange("Date", AsOfDate);

        if not LiquidityMetric.IsEmpty() then
            LiquidityMetric.DeleteAll();

        InsertLiquidityMetric(
            Enum::"Liquidity Metric Type"::"Cash at Bank",
            GetCashAtBank(AsOfDate),
            AsOfDate);

        InsertLiquidityMetric(
            Enum::"Liquidity Metric Type"::"Cash on Hand",
            GetCashOnHand(AsOfDate),
            AsOfDate);

        InsertLiquidityMetric(
            Enum::"Liquidity Metric Type"::"Total Liquid Assets",
            GetTotalLiquidAssets(AsOfDate),
            AsOfDate);

        InsertLiquidityMetric(
            Enum::"Liquidity Metric Type"::"Expected Loan Disbursements",
            GetExpectedLoanDisbursements(AsOfDate),
            AsOfDate);

        InsertLiquidityMetric(
            Enum::"Liquidity Metric Type"::"Expected Collections Today",
            GetExpectedCollectionsToday(AsOfDate),
            AsOfDate);

        InsertLiquidityMetric(
            Enum::"Liquidity Metric Type"::"Net Liquidity Position",
            GetNetLiquidityPosition(AsOfDate),
            AsOfDate);

        InsertLiquidityMetric(
            Enum::"Liquidity Metric Type"::"Liquidity Ratio",
            GetLiquidityRatio(AsOfDate),
            AsOfDate);
    end;


    // ---------------------------------------------------------
    // CASH FLOW FORECAST
    // ---------------------------------------------------------
    //
    // IMPORTANT:
    // "Cash Flow Forecast Entry" is Microsoft's standard BC table.
    // It does NOT contain Period, Inflows or Outflows fields.
    //
    // Therefore this procedure calculates the forecast but does
    // not insert artificial records into the standard BC table.
    //
    procedure PopulateCashFlowForecast(FromDate: Date; ToDate: Date)
    var
        TodayInflows: Decimal;
        TodayOutflows: Decimal;
        SevenDayInflows: Decimal;
        SevenDayOutflows: Decimal;
        ThirtyDayInflows: Decimal;
        ThirtyDayOutflows: Decimal;
    begin
        if FromDate = 0D then
            exit;

        if ToDate = 0D then
            ToDate := FromDate + 30;

        if ToDate < FromDate then
            Error(
                'The To Date (%1) cannot be earlier than the From Date (%2).',
                ToDate,
                FromDate);

        // Today
        TodayInflows := GetInflows(FromDate, FromDate);
        TodayOutflows := GetOutflows(FromDate, FromDate);

        // Next 7 days
        SevenDayInflows := GetInflows(FromDate, FromDate + 7);
        SevenDayOutflows := GetOutflows(FromDate, FromDate + 7);

        // Requested period / normally 30 days
        ThirtyDayInflows := GetInflows(FromDate, ToDate);
        ThirtyDayOutflows := GetOutflows(FromDate, ToDate);

        // The values are intentionally calculated here rather than
        // inserted into Microsoft's Cash Flow Forecast Entry table.
        //
        // They can be consumed by:
        // - LiquidityReport
        // - API/page procedures
        // - a custom liquidity summary table
        //
        // Do not insert synthetic "Period", "Inflows", or "Outflows"
        // records into the standard BC Cash Flow Forecast Entry table.
    end;


    // ---------------------------------------------------------
    // INSERT LIQUIDITY METRIC
    // ---------------------------------------------------------

    local procedure InsertLiquidityMetric(
        MetricType: Enum "Liquidity Metric Type";
        Amount: Decimal;
        EntryDate: Date)
    var
        LiquidityMetric: Record "Liquidity Metric";
    begin
        LiquidityMetric.Init();

        LiquidityMetric.Metric := MetricType;
        LiquidityMetric.Amount := Amount;
        LiquidityMetric."Date" := EntryDate;

        LiquidityMetric.Insert(true);
    end;


    // ---------------------------------------------------------
    // CASH AT BANK
    // ---------------------------------------------------------

    local procedure GetCashAtBank(AsOfDate: Date): Decimal
    var
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
    begin
        if AsOfDate = 0D then
            exit(0);

        BankAccountLedgerEntry.Reset();

        BankAccountLedgerEntry.SetRange(
            "Posting Date",
            0D,
            AsOfDate);

        BankAccountLedgerEntry.CalcSums(Amount);

        exit(BankAccountLedgerEntry.Amount);
    end;


    // ---------------------------------------------------------
    // CASH ON HAND
    // ---------------------------------------------------------
    //
    // This uses the custom Bank Account Detail table if it exists.
    //
    // If your "Cash on Hand" is maintained through a G/L account
    // instead, we can change this later to use a dedicated
    // Cash-on-Hand G/L account.
    //

    local procedure GetCashOnHand(AsOfDate: Date): Decimal
    begin
        exit(GetTotalFromBankAccountDetail(AsOfDate));
    end;


    // ---------------------------------------------------------
    // TOTAL LIQUID ASSETS
    // ---------------------------------------------------------

    local procedure GetTotalLiquidAssets(AsOfDate: Date): Decimal
    begin
        exit(
            GetCashAtBank(AsOfDate) +
            GetCashOnHand(AsOfDate));
    end;


    // ---------------------------------------------------------
    // EXPECTED LOAN DISBURSEMENTS
    // ---------------------------------------------------------

    local procedure GetExpectedLoanDisbursements(
        AsOfDate: Date): Decimal
    var
        LoanDisbursement: Record "Loan Disbursement";
        Total: Decimal;
    begin
        Total := 0;

        LoanDisbursement.Reset();

        LoanDisbursement.SetRange(
            "Posting Date",
            AsOfDate);

        LoanDisbursement.SetRange(
            "Status",
            LoanDisbursement.Status::Pending);

        if LoanDisbursement.FindSet() then
            repeat
                Total += LoanDisbursement.Amount;
            until LoanDisbursement.Next() = 0;

        exit(Total);
    end;


    // ---------------------------------------------------------
    // EXPECTED COLLECTIONS
    // ---------------------------------------------------------

    local procedure GetExpectedCollectionsToday(
        AsOfDate: Date): Decimal
    begin
        // TODO:
        // Connect this to your loan repayment/schedule table.
        //
        // For now there is no source table in the supplied code
        // that defines expected collections.
        exit(0);
    end;


    // ---------------------------------------------------------
    // NET LIQUIDITY POSITION
    // ---------------------------------------------------------
    //
    // Liquid assets
    // + expected collections
    // - expected loan disbursements
    //
    // Loan disbursements are cash going OUT, so they should not
    // be added to the liquidity position.
    //

    local procedure GetNetLiquidityPosition(
        AsOfDate: Date): Decimal
    var
        LiquidAssets: Decimal;
        ExpectedDisbursements: Decimal;
        ExpectedCollections: Decimal;
    begin
        LiquidAssets := GetTotalLiquidAssets(AsOfDate);

        ExpectedDisbursements :=
            GetExpectedLoanDisbursements(AsOfDate);

        ExpectedCollections :=
            GetExpectedCollectionsToday(AsOfDate);

        exit(
            LiquidAssets
            + ExpectedCollections
            - ExpectedDisbursements);
    end;


    // ---------------------------------------------------------
    // LIQUIDITY RATIO
    // ---------------------------------------------------------
    //
    // Current implementation:
    //
    // Liquid Assets / Net Liquidity Position
    //
    // Returns 0 if denominator is zero.
    //

    local procedure GetLiquidityRatio(
        AsOfDate: Date): Decimal
    var
        LiquidAssets: Decimal;
        NetLiquidity: Decimal;
    begin
        LiquidAssets := GetTotalLiquidAssets(AsOfDate);
        NetLiquidity := GetNetLiquidityPosition(AsOfDate);

        if NetLiquidity = 0 then
            exit(0);

        exit(
            LiquidAssets /
            Abs(NetLiquidity));
    end;


    // ---------------------------------------------------------
    // INFLOWS
    // ---------------------------------------------------------
    //
    // G/L Debit Amount is used as the inflow measure based on
    // the logic from your original implementation.
    //

    local procedure GetInflows(
        FromDate: Date;
        ToDate: Date): Decimal
    var
        GLEntry: Record "G/L Entry";
    begin
        if FromDate = 0D then
            exit(0);

        if ToDate = 0D then
            ToDate := FromDate;

        if ToDate < FromDate then
            exit(0);

        GLEntry.Reset();

        GLEntry.SetRange(
            "Posting Date",
            FromDate,
            ToDate);

        GLEntry.SetFilter(
            "Debit Amount",
            '>0');

        GLEntry.CalcSums(
            "Debit Amount");

        exit(GLEntry."Debit Amount");
    end;


    // ---------------------------------------------------------
    // OUTFLOWS
    // ---------------------------------------------------------

    local procedure GetOutflows(
        FromDate: Date;
        ToDate: Date): Decimal
    var
        GLEntry: Record "G/L Entry";
    begin
        if FromDate = 0D then
            exit(0);

        if ToDate = 0D then
            ToDate := FromDate;

        if ToDate < FromDate then
            exit(0);

        GLEntry.Reset();

        GLEntry.SetRange(
            "Posting Date",
            FromDate,
            ToDate);

        GLEntry.SetFilter(
            "Credit Amount",
            '>0');

        GLEntry.CalcSums(
            "Credit Amount");

        exit(GLEntry."Credit Amount");
    end;


    // ---------------------------------------------------------
    // BANK ACCOUNT DETAIL TOTAL
    // ---------------------------------------------------------

    local procedure GetTotalFromBankAccountDetail(
        AsOfDate: Date): Decimal
    var
        BankAccountDetail: Record "Bank Account Detail";
        Total: Decimal;
    begin
        Total := 0;

        if AsOfDate = 0D then
            exit(0);

        BankAccountDetail.Reset();

        BankAccountDetail.SetRange(
            "As Of Date",
            AsOfDate);

        if BankAccountDetail.FindSet() then
            repeat
                Total += BankAccountDetail.Balance;
            until BankAccountDetail.Next() = 0;

        exit(Total);
    end;
}