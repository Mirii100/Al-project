

// // codeunit 50111 "Liquidity Report Mgt."
// // {
// //     procedure PopulateLiquidityMetrics(AsOfDate: Date)
// //     var
// //         LiquidityMetric: Record "Liquidity Metric";
// //     begin
// //         // Remove only the BOSA liquidity metrics for this date.
// //         // This does NOT touch Microsoft's Cash Flow Forecast Entry table.
// //         LiquidityMetric.SetRange("Date", AsOfDate);

// //         if not LiquidityMetric.IsEmpty() then
// //             LiquidityMetric.DeleteAll();

// //         InsertLiquidityMetric(
// //             Enum::"Liquidity Metric Type"::"Cash at Bank",
// //             GetCashAtBank(AsOfDate),
// //             AsOfDate);

// //         InsertLiquidityMetric(
// //             Enum::"Liquidity Metric Type"::"Cash on Hand",
// //             GetCashOnHand(AsOfDate),
// //             AsOfDate);

// //         InsertLiquidityMetric(
// //             Enum::"Liquidity Metric Type"::"Total Liquid Assets",
// //             GetTotalLiquidAssets(AsOfDate),
// //             AsOfDate);

// //         InsertLiquidityMetric(
// //             Enum::"Liquidity Metric Type"::"Expected Loan Disbursements",
// //             GetExpectedLoanDisbursements(AsOfDate),
// //             AsOfDate);

// //         InsertLiquidityMetric(
// //             Enum::"Liquidity Metric Type"::"Expected Collections Today",
// //             GetExpectedCollectionsToday(AsOfDate),
// //             AsOfDate);

// //         InsertLiquidityMetric(
// //             Enum::"Liquidity Metric Type"::"Net Liquidity Position",
// //             GetNetLiquidityPosition(AsOfDate),
// //             AsOfDate);

// //         InsertLiquidityMetric(
// //             Enum::"Liquidity Metric Type"::"Liquidity Ratio",
// //             GetLiquidityRatio(AsOfDate),
// //             AsOfDate);
// //     end;


// //     // ---------------------------------------------------------
// //     // CASH FLOW FORECAST
// //     // ---------------------------------------------------------
// //     //
// //     // IMPORTANT:
// //     // "Cash Flow Forecast Entry" is Microsoft's standard BC table.
// //     // It does NOT contain Period, Inflows or Outflows fields.
// //     //
// //     // Therefore this procedure calculates the forecast but does
// //     // not insert artificial records into the standard BC table.
// //     //
// //     procedure PopulateCashFlowForecast(FromDate: Date; ToDate: Date)
// //     var
// //         TodayInflows: Decimal;
// //         TodayOutflows: Decimal;
// //         SevenDayInflows: Decimal;
// //         SevenDayOutflows: Decimal;
// //         ThirtyDayInflows: Decimal;
// //         ThirtyDayOutflows: Decimal;
// //     begin
// //         if FromDate = 0D then
// //             exit;

// //         if ToDate = 0D then
// //             ToDate := FromDate + 30;

// //         if ToDate < FromDate then
// //             Error(
// //                 'The To Date (%1) cannot be earlier than the From Date (%2).',
// //                 ToDate,
// //                 FromDate);

// //         // Today
// //         TodayInflows := GetInflows(FromDate, FromDate);
// //         TodayOutflows := GetOutflows(FromDate, FromDate);

// //         // Next 7 days
// //         SevenDayInflows := GetInflows(FromDate, FromDate + 7);
// //         SevenDayOutflows := GetOutflows(FromDate, FromDate + 7);

// //         // Requested period / normally 30 days
// //         ThirtyDayInflows := GetInflows(FromDate, ToDate);
// //         ThirtyDayOutflows := GetOutflows(FromDate, ToDate);

// //         // The values are intentionally calculated here rather than
// //         // inserted into Microsoft's Cash Flow Forecast Entry table.
// //         //
// //         // They can be consumed by:
// //         // - LiquidityReport
// //         // - API/page procedures
// //         // - a custom liquidity summary table
// //         //
// //         // Do not insert synthetic "Period", "Inflows", or "Outflows"
// //         // records into the standard BC Cash Flow Forecast Entry table.
// //     end;


// //     // ---------------------------------------------------------
// //     // INSERT LIQUIDITY METRIC
// //     // ---------------------------------------------------------

// //     local procedure InsertLiquidityMetric(
// //         MetricType: Enum "Liquidity Metric Type";
// //         Amount: Decimal;
// //         EntryDate: Date)
// //     var
// //         LiquidityMetric: Record "Liquidity Metric";
// //     begin
// //         LiquidityMetric.Init();

// //         LiquidityMetric.Metric := MetricType;
// //         LiquidityMetric.Amount := Amount;
// //         LiquidityMetric."Date" := EntryDate;

// //         LiquidityMetric.Insert(true);
// //     end;


// //     // ---------------------------------------------------------
// //     // CASH AT BANK
// //     // ---------------------------------------------------------

// //     local procedure GetCashAtBank(AsOfDate: Date): Decimal
// //     var
// //         BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
// //     begin
// //         if AsOfDate = 0D then
// //             exit(0);

// //         BankAccountLedgerEntry.Reset();

// //         BankAccountLedgerEntry.SetRange(
// //             "Posting Date",
// //             0D,
// //             AsOfDate);

// //         BankAccountLedgerEntry.CalcSums(Amount);

// //         exit(BankAccountLedgerEntry.Amount);
// //     end;


// //     // ---------------------------------------------------------
// //     // CASH ON HAND
// //     // ---------------------------------------------------------
// //     //
// //     // This uses the custom Bank Account Detail table if it exists.
// //     //
// //     // If your "Cash on Hand" is maintained through a G/L account
// //     // instead, we can change this later to use a dedicated
// //     // Cash-on-Hand G/L account.
// //     //

// //     local procedure GetCashOnHand(AsOfDate: Date): Decimal
// //     begin
// //         exit(GetTotalFromBankAccountDetail(AsOfDate));
// //     end;


// //     // ---------------------------------------------------------
// //     // TOTAL LIQUID ASSETS
// //     // ---------------------------------------------------------

// //     local procedure GetTotalLiquidAssets(AsOfDate: Date): Decimal
// //     begin
// //         exit(
// //             GetCashAtBank(AsOfDate) +
// //             GetCashOnHand(AsOfDate));
// //     end;


// //     // ---------------------------------------------------------
// //     // EXPECTED LOAN DISBURSEMENTS
// //     // ---------------------------------------------------------

// //     local procedure GetExpectedLoanDisbursements(
// //         AsOfDate: Date): Decimal
// //     var
// //         LoanDisbursement: Record "Loan Disbursement";
// //         Total: Decimal;
// //     begin
// //         Total := 0;

// //         LoanDisbursement.Reset();

// //         LoanDisbursement.SetRange(
// //             "Posting Date",
// //             AsOfDate);

// //         LoanDisbursement.SetRange(
// //             "Status",
// //             LoanDisbursement.Status::Pending);

// //         if LoanDisbursement.FindSet() then
// //             repeat
// //                 Total += LoanDisbursement.Amount;
// //             until LoanDisbursement.Next() = 0;

// //         exit(Total);
// //     end;


// //     // ---------------------------------------------------------
// //     // EXPECTED COLLECTIONS
// //     // ---------------------------------------------------------

// //     local procedure GetExpectedCollectionsToday(
// //         AsOfDate: Date): Decimal
// //     begin
// //         // TODO:
// //         // Connect this to your loan repayment/schedule table.
// //         //
// //         // For now there is no source table in the supplied code
// //         // that defines expected collections.
// //         exit(0);
// //     end;


// //     // ---------------------------------------------------------
// //     // NET LIQUIDITY POSITION
// //     // ---------------------------------------------------------
// //     //
// //     // Liquid assets
// //     // + expected collections
// //     // - expected loan disbursements
// //     //
// //     // Loan disbursements are cash going OUT, so they should not
// //     // be added to the liquidity position.
// //     //

// //     local procedure GetNetLiquidityPosition(
// //         AsOfDate: Date): Decimal
// //     var
// //         LiquidAssets: Decimal;
// //         ExpectedDisbursements: Decimal;
// //         ExpectedCollections: Decimal;
// //     begin
// //         LiquidAssets := GetTotalLiquidAssets(AsOfDate);

// //         ExpectedDisbursements :=
// //             GetExpectedLoanDisbursements(AsOfDate);

// //         ExpectedCollections :=
// //             GetExpectedCollectionsToday(AsOfDate);

// //         exit(
// //             LiquidAssets
// //             + ExpectedCollections
// //             - ExpectedDisbursements);
// //     end;


// //     // ---------------------------------------------------------
// //     // LIQUIDITY RATIO
// //     // ---------------------------------------------------------
// //     //
// //     // Current implementation:
// //     //
// //     // Liquid Assets / Net Liquidity Position
// //     //
// //     // Returns 0 if denominator is zero.
// //     //

// //     local procedure GetLiquidityRatio(
// //         AsOfDate: Date): Decimal
// //     var
// //         LiquidAssets: Decimal;
// //         NetLiquidity: Decimal;
// //     begin
// //         LiquidAssets := GetTotalLiquidAssets(AsOfDate);
// //         NetLiquidity := GetNetLiquidityPosition(AsOfDate);

// //         if NetLiquidity = 0 then
// //             exit(0);

// //         exit(
// //             LiquidAssets /
// //             Abs(NetLiquidity));
// //     end;


// //     // ---------------------------------------------------------
// //     // INFLOWS
// //     // ---------------------------------------------------------
// //     //
// //     // G/L Debit Amount is used as the inflow measure based on
// //     // the logic from your original implementation.
// //     //

// //     local procedure GetInflows(
// //         FromDate: Date;
// //         ToDate: Date): Decimal
// //     var
// //         GLEntry: Record "G/L Entry";
// //     begin
// //         if FromDate = 0D then
// //             exit(0);

// //         if ToDate = 0D then
// //             ToDate := FromDate;

// //         if ToDate < FromDate then
// //             exit(0);

// //         GLEntry.Reset();

// //         GLEntry.SetRange(
// //             "Posting Date",
// //             FromDate,
// //             ToDate);

// //         GLEntry.SetFilter(
// //             "Debit Amount",
// //             '>0');

// //         GLEntry.CalcSums(
// //             "Debit Amount");

// //         exit(GLEntry."Debit Amount");
// //     end;


// //     // ---------------------------------------------------------
// //     // OUTFLOWS
// //     // ---------------------------------------------------------

// //     local procedure GetOutflows(
// //         FromDate: Date;
// //         ToDate: Date): Decimal
// //     var
// //         GLEntry: Record "G/L Entry";
// //     begin
// //         if FromDate = 0D then
// //             exit(0);

// //         if ToDate = 0D then
// //             ToDate := FromDate;

// //         if ToDate < FromDate then
// //             exit(0);

// //         GLEntry.Reset();

// //         GLEntry.SetRange(
// //             "Posting Date",
// //             FromDate,
// //             ToDate);

// //         GLEntry.SetFilter(
// //             "Credit Amount",
// //             '>0');

// //         GLEntry.CalcSums(
// //             "Credit Amount");

// //         exit(GLEntry."Credit Amount");
// //     end;


// //     // ---------------------------------------------------------
// //     // BANK ACCOUNT DETAIL TOTAL
// //     // ---------------------------------------------------------

// //     local procedure GetTotalFromBankAccountDetail(
// //         AsOfDate: Date): Decimal
// //     var
// //         BankAccountDetail: Record "Bank Account Detail";
// //         Total: Decimal;
// //     begin
// //         Total := 0;

// //         if AsOfDate = 0D then
// //             exit(0);

// //         BankAccountDetail.Reset();

// //         BankAccountDetail.SetRange(
// //             "As Of Date",
// //             AsOfDate);

// //         if BankAccountDetail.FindSet() then
// //             repeat
// //                 Total += BankAccountDetail.Balance;
// //             until BankAccountDetail.Next() = 0;

// //         exit(Total);
// //     end;
// // }

// codeunit 50111 "Liquidity Report Mgt."
// {
//     // =========================================================
//     // PUBLIC PROCEDURES
//     // =========================================================

//     procedure PopulateLiquidityMetrics(AsOfDate: Date)
//     var
//         LiquidityMetric: Record "Liquidity Metric";
//     begin
//         if AsOfDate = 0D then
//             AsOfDate := WorkDate();

//         // Delete only metrics belonging to this date.
//         LiquidityMetric.Reset();
//         LiquidityMetric.SetRange("Date", AsOfDate);

//         if not LiquidityMetric.IsEmpty() then
//             LiquidityMetric.DeleteAll();

//         // -----------------------------------------------------
//         // CASH AT BANK
//         // -----------------------------------------------------

//         InsertLiquidityMetric(
//             Enum::"Liquidity Metric Type"::"Cash at Bank",
//             GetCashAtBank(AsOfDate),
//             AsOfDate);

//         // -----------------------------------------------------
//         // CASH ON HAND
//         // -----------------------------------------------------

//         InsertLiquidityMetric(
//             Enum::"Liquidity Metric Type"::"Cash on Hand",
//             GetCashOnHand(AsOfDate),
//             AsOfDate);

//         // -----------------------------------------------------
//         // TOTAL LIQUID ASSETS
//         // -----------------------------------------------------

//         InsertLiquidityMetric(
//             Enum::"Liquidity Metric Type"::"Total Liquid Assets",
//             GetTotalLiquidAssets(AsOfDate),
//             AsOfDate);

//         // -----------------------------------------------------
//         // EXPECTED LOAN DISBURSEMENTS
//         // -----------------------------------------------------

//         InsertLiquidityMetric(
//             Enum::"Liquidity Metric Type"::"Expected Loan Disbursements",
//             GetExpectedLoanDisbursements(AsOfDate),
//             AsOfDate);

//         // -----------------------------------------------------
//         // EXPECTED COLLECTIONS
//         // -----------------------------------------------------

//         InsertLiquidityMetric(
//             Enum::"Liquidity Metric Type"::"Expected Collections Today",
//             GetExpectedCollectionsToday(AsOfDate),
//             AsOfDate);

//         // -----------------------------------------------------
//         // NET LIQUIDITY
//         // -----------------------------------------------------

//         InsertLiquidityMetric(
//             Enum::"Liquidity Metric Type"::"Net Liquidity Position",
//             GetNetLiquidityPosition(AsOfDate),
//             AsOfDate);

//         // -----------------------------------------------------
//         // LIQUIDITY RATIO
//         // -----------------------------------------------------

//         InsertLiquidityMetric(
//             Enum::"Liquidity Metric Type"::"Liquidity Ratio",
//             GetLiquidityRatio(AsOfDate),
//             AsOfDate);
//     end;


//     procedure PopulateCashFlowForecast(
//         FromDate: Date;
//         ToDate: Date)
//     var
//         TodayInflows: Decimal;
//         TodayOutflows: Decimal;

//         SevenDayInflows: Decimal;
//         SevenDayOutflows: Decimal;

//         ThirtyDayInflows: Decimal;
//         ThirtyDayOutflows: Decimal;
//     begin
//         if FromDate = 0D then
//             FromDate := WorkDate();

//         if ToDate = 0D then
//             ToDate := FromDate + 30;

//         if ToDate < FromDate then
//             Error(
//                 'The To Date (%1) cannot be earlier than the From Date (%2).',
//                 ToDate,
//                 FromDate);

//         // -----------------------------------------------------
//         // Remove existing BOSA forecast records for this range.
//         // This DOES NOT touch Microsoft's Cash Flow Forecast Entry.
//         // -----------------------------------------------------

//         DeleteExistingCashFlowSummary(FromDate, ToDate);

//         // -----------------------------------------------------
//         // TODAY
//         // -----------------------------------------------------

//         TodayInflows :=
//             GetInflows(
//                 FromDate,
//                 FromDate);

//         TodayOutflows :=
//             GetOutflows(
//                 FromDate,
//                 FromDate);

//         InsertCashFlowSummary(
//             Enum::"Cash Flow Period Type"::Today,
//             FromDate,
//             FromDate,
//             TodayInflows,
//             TodayOutflows);

//         // -----------------------------------------------------
//         // NEXT 7 DAYS
//         // -----------------------------------------------------

//         SevenDayInflows :=
//             GetInflows(
//                 FromDate,
//                 FromDate + 7);

//         SevenDayOutflows :=
//             GetOutflows(
//                 FromDate,
//                 FromDate + 7);

//         InsertCashFlowSummary(
//             Enum::"Cash Flow Period Type"::"7 Days",
//             FromDate,
//             FromDate + 7,
//             SevenDayInflows,
//             SevenDayOutflows);

//         // -----------------------------------------------------
//         // NEXT 30 DAYS
//         // -----------------------------------------------------

//         ThirtyDayInflows :=
//             GetInflows(
//                 FromDate,
//                 ToDate);

//         ThirtyDayOutflows :=
//             GetOutflows(
//                 FromDate,
//                 ToDate);

//         InsertCashFlowSummary(
//             Enum::"Cash Flow Period Type"::"30 Days",
//             FromDate,
//             ToDate,
//             ThirtyDayInflows,
//             ThirtyDayOutflows);
//     end;


//     // =========================================================
//     // INSERT LIQUIDITY METRIC
//     // =========================================================

//     local procedure InsertLiquidityMetric(
//         MetricType: Enum "Liquidity Metric Type";
//         MetricAmount: Decimal;
//         EntryDate: Date)
//     var
//         LiquidityMetric: Record "Liquidity Metric";
//     begin
//         LiquidityMetric.Init();

//         LiquidityMetric.Metric :=
//             MetricType;

//         LiquidityMetric.Amount :=
//             MetricAmount;

//         LiquidityMetric."Date" :=
//             EntryDate;

//         LiquidityMetric.Insert(true);
//     end;


//     // =========================================================
//     // INSERT CASH FLOW SUMMARY
//     // =========================================================

//     local procedure InsertCashFlowSummary(
//         PeriodType: Enum "Cash Flow Period Type";
//         FromDate: Date;
//         ToDate: Date;
//         Inflows: Decimal;
//         Outflows: Decimal)
//     var
//         CashFlowSummary: Record "BOSA Cash Flow Summary";
//     begin
//         CashFlowSummary.Init();

//         CashFlowSummary.Period :=
//             PeriodType;

//         CashFlowSummary."From Date" :=
//             FromDate;

//         CashFlowSummary."To Date" :=
//             ToDate;

//         CashFlowSummary.Inflows :=
//             Inflows;

//         CashFlowSummary.Outflows :=
//             Outflows;

//         CashFlowSummary."Net Cash" :=
//             Inflows - Outflows;

//         CashFlowSummary."Date" :=
//             FromDate;

//         CashFlowSummary.Insert(true);
//     end;


//     // =========================================================
//     // DELETE EXISTING CASH FLOW SUMMARY
//     // =========================================================

//     local procedure DeleteExistingCashFlowSummary(
//         FromDate: Date;
//         ToDate: Date)
//     var
//         CashFlowSummary: Record "BOSA Cash Flow Summary";
//     begin
//         CashFlowSummary.Reset();

//         CashFlowSummary.SetFilter(
//             "From Date",
//             '>=%1&<=%2',
//             FromDate,
//             ToDate);

//         if not CashFlowSummary.IsEmpty() then
//             CashFlowSummary.DeleteAll();
//     end;


//     // =========================================================
//     // CASH AT BANK
//     // =========================================================

//     local procedure GetCashAtBank(
//         AsOfDate: Date): Decimal
//     var
//         BankAccountLedgerEntry:
//             Record "Bank Account Ledger Entry";
//     begin
//         if AsOfDate = 0D then
//             exit(0);

//         BankAccountLedgerEntry.Reset();

//         BankAccountLedgerEntry.SetRange(
//             "Posting Date",
//             0D,
//             AsOfDate);

//         BankAccountLedgerEntry.CalcSums(
//             Amount);

//         exit(
//             BankAccountLedgerEntry.Amount);
//     end;


//     // =========================================================
//     // CASH ON HAND
//     // =========================================================

//     local procedure GetCashOnHand(
//         AsOfDate: Date): Decimal
//     begin
//         if AsOfDate = 0D then
//             exit(0);

//         exit(
//             GetTotalFromBankAccountDetail(
//                 AsOfDate));
//     end;


//     // =========================================================
//     // TOTAL LIQUID ASSETS
//     // =========================================================

//     local procedure GetTotalLiquidAssets(
//         AsOfDate: Date): Decimal
//     begin
//         exit(
//             GetCashAtBank(AsOfDate)
//             +
//             GetCashOnHand(AsOfDate));
//     end;


//     // =========================================================
//     // EXPECTED LOAN DISBURSEMENTS
//     // =========================================================

//     local procedure GetExpectedLoanDisbursements(
//         AsOfDate: Date): Decimal
//     var
//         LoanDisbursement:
//             Record "Loan Disbursement";

//         TotalAmount: Decimal;
//     begin
//         if AsOfDate = 0D then
//             exit(0);

//         TotalAmount := 0;

//         LoanDisbursement.Reset();

//         LoanDisbursement.SetRange(
//             "Posting Date",
//             AsOfDate);

//         LoanDisbursement.SetRange(
//             "Status",
//             LoanDisbursement.Status::Pending);

//         if LoanDisbursement.FindSet() then
//             repeat
//                 TotalAmount :=
//                     TotalAmount
//                     +
//                     LoanDisbursement.Amount;
//             until LoanDisbursement.Next() = 0;

//         exit(TotalAmount);
//     end;


//     // =========================================================
//     // EXPECTED COLLECTIONS TODAY
//     // =========================================================

//     local procedure GetExpectedCollectionsToday(
//         AsOfDate: Date): Decimal
//     var
//         LoanSchedule:
//             Record "Loan Schedule";

//         TotalCollections: Decimal;
//     begin
//         if AsOfDate = 0D then
//             exit(0);

//         TotalCollections := 0;

//         LoanSchedule.Reset();

//         // IMPORTANT:
//         // These field names must exist in your Loan Schedule table.
//         //
//         // If your actual table uses different names, change:
//         //
//         // "Due Date"
//         // "Amount"
//         // "Status"

//         LoanSchedule.SetRange(
//             "Due Date",
//             AsOfDate);

//         if LoanSchedule.FindSet() then
//             repeat
//                 TotalCollections :=
//                     TotalCollections
//                     +
//                     LoanSchedule.Amount;
//             until LoanSchedule.Next() = 0;

//         exit(TotalCollections);
//     end;


//     // =========================================================
//     // NET LIQUIDITY POSITION
//     // =========================================================

//     local procedure GetNetLiquidityPosition(
//         AsOfDate: Date): Decimal
//     var
//         LiquidAssets: Decimal;
//         ExpectedCollections: Decimal;
//         ExpectedDisbursements: Decimal;
//     begin
//         LiquidAssets :=
//             GetTotalLiquidAssets(
//                 AsOfDate);

//         ExpectedCollections :=
//             GetExpectedCollectionsToday(
//                 AsOfDate);

//         ExpectedDisbursements :=
//             GetExpectedLoanDisbursements(
//                 AsOfDate);

//         exit(
//             LiquidAssets
//             +
//             ExpectedCollections
//             -
//             ExpectedDisbursements);
//     end;


//     // =========================================================
//     // LIQUIDITY RATIO
//     // =========================================================

//     local procedure GetLiquidityRatio(
//         AsOfDate: Date): Decimal
//     var
//         LiquidAssets: Decimal;
//         NetLiquidity: Decimal;
//     begin
//         LiquidAssets :=
//             GetTotalLiquidAssets(
//                 AsOfDate);

//         NetLiquidity :=
//             GetNetLiquidityPosition(
//                 AsOfDate);

//         if NetLiquidity = 0 then
//             exit(0);

//         exit(
//             LiquidAssets
//             /
//             Abs(NetLiquidity));
//     end;


//     // =========================================================
//     // INFLOWS
//     // =========================================================

//     local procedure GetInflows(
//         FromDate: Date;
//         ToDate: Date): Decimal
//     var
//         GLEntry:
//             Record "G/L Entry";
//     begin
//         if FromDate = 0D then
//             exit(0);

//         if ToDate = 0D then
//             ToDate := FromDate;

//         if ToDate < FromDate then
//             exit(0);

//         GLEntry.Reset();

//         GLEntry.SetRange(
//             "Posting Date",
//             FromDate,
//             ToDate);

//         GLEntry.SetFilter(
//             "Debit Amount",
//             '>0');

//         GLEntry.CalcSums(
//             "Debit Amount");

//         exit(
//             GLEntry."Debit Amount");
//     end;


//     // =========================================================
//     // OUTFLOWS
//     // =========================================================

//     local procedure GetOutflows(
//         FromDate: Date;
//         ToDate: Date): Decimal
//     var
//         GLEntry:
//             Record "G/L Entry";
//     begin
//         if FromDate = 0D then
//             exit(0);

//         if ToDate = 0D then
//             ToDate := FromDate;

//         if ToDate < FromDate then
//             exit(0);

//         GLEntry.Reset();

//         GLEntry.SetRange(
//             "Posting Date",
//             FromDate,
//             ToDate);

//         GLEntry.SetFilter(
//             "Credit Amount",
//             '>0');

//         GLEntry.CalcSums(
//             "Credit Amount");

//         exit(
//             GLEntry."Credit Amount");
//     end;


//     // =========================================================
//     // BANK ACCOUNT DETAIL TOTAL
//     // =========================================================

//     local procedure GetTotalFromBankAccountDetail(
//         AsOfDate: Date): Decimal
//     var
//         BankAccountDetail:
//             Record "Bank Account Detail";

//         TotalAmount: Decimal;
//     begin
//         if AsOfDate = 0D then
//             exit(0);

//         TotalAmount := 0;

//         BankAccountDetail.Reset();

//         BankAccountDetail.SetRange(
//             "As Of Date",
//             AsOfDate);

//         if BankAccountDetail.FindSet() then
//             repeat
//                 TotalAmount :=
//                     TotalAmount
//                     +
//                     BankAccountDetail.Balance;
//             until BankAccountDetail.Next() = 0;

//         exit(TotalAmount);
//     end;
// }

codeunit 50111 "Liquidity Report Mgt."
{
    // =========================================================
    // POPULATE LIQUIDITY METRICS
    // =========================================================

    procedure PopulateLiquidityMetrics(AsOfDate: Date)
    var
        LiquidityMetric: Record "Liquidity Metric";
    begin
        if AsOfDate = 0D then
            AsOfDate := WorkDate();

        // Remove existing metrics for this date.
        LiquidityMetric.Reset();
        LiquidityMetric.SetRange("Date", AsOfDate);

        if not LiquidityMetric.IsEmpty() then
            LiquidityMetric.DeleteAll();

        // Cash at bank
        InsertLiquidityMetric(
            Enum::"Liquidity Metric Type"::"Cash at Bank",
            GetCashAtBank(AsOfDate),
            AsOfDate);

        // Cash on hand
        InsertLiquidityMetric(
            Enum::"Liquidity Metric Type"::"Cash on Hand",
            GetCashOnHand(AsOfDate),
            AsOfDate);

        // Total liquid assets
        InsertLiquidityMetric(
            Enum::"Liquidity Metric Type"::"Total Liquid Assets",
            GetTotalLiquidAssets(AsOfDate),
            AsOfDate);

        // Expected loan disbursements
        InsertLiquidityMetric(
            Enum::"Liquidity Metric Type"::"Expected Loan Disbursements",
            GetExpectedLoanDisbursements(AsOfDate),
            AsOfDate);

        // Expected collections
        InsertLiquidityMetric(
            Enum::"Liquidity Metric Type"::"Expected Collections Today",
            GetExpectedCollectionsToday(AsOfDate),
            AsOfDate);

        // Net liquidity position
        InsertLiquidityMetric(
            Enum::"Liquidity Metric Type"::"Net Liquidity Position",
            GetNetLiquidityPosition(AsOfDate),
            AsOfDate);

        // Liquidity ratio
        InsertLiquidityMetric(
            Enum::"Liquidity Metric Type"::"Liquidity Ratio",
            GetLiquidityRatio(AsOfDate),
            AsOfDate);
    end;


    // =========================================================
    // CASH FLOW CALCULATIONS
    // =========================================================

    procedure CalculateTodayInflows(AsOfDate: Date): Decimal
    begin
        if AsOfDate = 0D then
            AsOfDate := WorkDate();

        exit(
            GetInflows(
                AsOfDate,
                AsOfDate));
    end;


    procedure CalculateTodayOutflows(AsOfDate: Date): Decimal
    begin
        if AsOfDate = 0D then
            AsOfDate := WorkDate();

        exit(
            GetOutflows(
                AsOfDate,
                AsOfDate));
    end;


    procedure CalculateSevenDayInflows(AsOfDate: Date): Decimal
    begin
        if AsOfDate = 0D then
            AsOfDate := WorkDate();

        exit(
            GetInflows(
                AsOfDate,
                AsOfDate + 6));
    end;


    procedure CalculateSevenDayOutflows(AsOfDate: Date): Decimal
    begin
        if AsOfDate = 0D then
            AsOfDate := WorkDate();

        exit(
            GetOutflows(
                AsOfDate,
                AsOfDate + 6));
    end;


    procedure CalculateThirtyDayInflows(AsOfDate: Date): Decimal
    begin
        if AsOfDate = 0D then
            AsOfDate := WorkDate();

        exit(
            GetInflows(
                AsOfDate,
                AsOfDate + 29));
    end;


    procedure CalculateThirtyDayOutflows(AsOfDate: Date): Decimal
    begin
        if AsOfDate = 0D then
            AsOfDate := WorkDate();

        exit(
            GetOutflows(
                AsOfDate,
                AsOfDate + 29));
    end;


    // =========================================================
    // INSERT LIQUIDITY METRIC
    // =========================================================

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


    // =========================================================
    // CASH AT BANK
    // =========================================================

    local procedure GetCashAtBank(
        AsOfDate: Date): Decimal
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

        exit(
            BankAccountLedgerEntry.Amount);
    end;


    // =========================================================
    // CASH ON HAND
    // =========================================================

    local procedure GetCashOnHand(
        AsOfDate: Date): Decimal
    begin
        if AsOfDate = 0D then
            exit(0);

        exit(
            GetTotalFromBankAccountDetail(
                AsOfDate));
    end;


    // =========================================================
    // TOTAL LIQUID ASSETS
    // =========================================================

    local procedure GetTotalLiquidAssets(
        AsOfDate: Date): Decimal
    var
        CashAtBank: Decimal;
        CashOnHand: Decimal;
    begin
        CashAtBank :=
            GetCashAtBank(
                AsOfDate);

        CashOnHand :=
            GetCashOnHand(
                AsOfDate);

        exit(
            CashAtBank +
            CashOnHand);
    end;


    // =========================================================
    // EXPECTED LOAN DISBURSEMENTS
    // =========================================================

    local procedure GetExpectedLoanDisbursements(
        AsOfDate: Date): Decimal
    var
        LoanDisbursement: Record "Loan Disbursement";
        Total: Decimal;
    begin
        if AsOfDate = 0D then
            exit(0);

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
                Total :=
                    Total +
                    LoanDisbursement.Amount;
            until LoanDisbursement.Next() = 0;

        exit(Total);
    end;


    // =========================================================
    // EXPECTED COLLECTIONS
    // =========================================================
    //
    // There is currently no confirmed BOSA repayment/schedule
    // table in the project supplied so far.
    //
    // Therefore this deliberately returns zero instead of
    // referencing a nonexistent table or field.
    //

    local procedure GetExpectedCollectionsToday(
        AsOfDate: Date): Decimal
    begin
        exit(0);
    end;


    // =========================================================
    // NET LIQUIDITY POSITION
    // =========================================================

    local procedure GetNetLiquidityPosition(
        AsOfDate: Date): Decimal
    var
        LiquidAssets: Decimal;
        ExpectedCollections: Decimal;
        ExpectedDisbursements: Decimal;
    begin
        LiquidAssets :=
            GetTotalLiquidAssets(
                AsOfDate);

        ExpectedCollections :=
            GetExpectedCollectionsToday(
                AsOfDate);

        ExpectedDisbursements :=
            GetExpectedLoanDisbursements(
                AsOfDate);

        // Money coming in increases liquidity.
        // Money going out decreases liquidity.

        exit(
            LiquidAssets
            + ExpectedCollections
            - ExpectedDisbursements);
    end;


    // =========================================================
    // LIQUIDITY RATIO
    // =========================================================

    local procedure GetLiquidityRatio(
        AsOfDate: Date): Decimal
    var
        LiquidAssets: Decimal;
        NetLiquidity: Decimal;
    begin
        LiquidAssets :=
            GetTotalLiquidAssets(
                AsOfDate);

        NetLiquidity :=
            GetNetLiquidityPosition(
                AsOfDate);

        if NetLiquidity = 0 then
            exit(0);

        exit(
            LiquidAssets /
            Abs(NetLiquidity));
    end;


    // =========================================================
    // G/L INFLOWS
    // =========================================================

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

        exit(
            GLEntry."Debit Amount");
    end;


    // =========================================================
    // G/L OUTFLOWS
    // =========================================================

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

        exit(
            GLEntry."Credit Amount");
    end;


    // =========================================================
    // BANK ACCOUNT DETAIL
    // =========================================================

    local procedure GetTotalFromBankAccountDetail(
        AsOfDate: Date): Decimal
    var
        BankAccountDetail: Record "Bank Account Detail";
        Total: Decimal;
    begin
        if AsOfDate = 0D then
            exit(0);

        Total := 0;

        BankAccountDetail.Reset();

        BankAccountDetail.SetRange(
            "As Of Date",
            AsOfDate);

        if BankAccountDetail.FindSet() then
            repeat
                Total :=
                    Total +
                    BankAccountDetail.Balance;
            until BankAccountDetail.Next() = 0;

        exit(Total);
    end;


    // =========================================================
    // PUBLIC SUMMARY PROCEDURES
    // =========================================================
    //
    // These procedures allow your pages/reports to read the
    // calculated values directly without requiring a fake
    // Cash Flow Forecast table.
    //

    procedure GetCashAtBankAmount(
        AsOfDate: Date): Decimal
    begin
        exit(
            GetCashAtBank(
                AsOfDate));
    end;


    procedure GetCashOnHandAmount(
        AsOfDate: Date): Decimal
    begin
        exit(
            GetCashOnHand(
                AsOfDate));
    end;


    procedure GetTotalLiquidAssetsAmount(
        AsOfDate: Date): Decimal
    begin
        exit(
            GetTotalLiquidAssets(
                AsOfDate));
    end;


    procedure GetExpectedLoanDisbursementsAmount(
        AsOfDate: Date): Decimal
    begin
        exit(
            GetExpectedLoanDisbursements(
                AsOfDate));
    end;


    procedure GetExpectedCollectionsAmount(
        AsOfDate: Date): Decimal
    begin
        exit(
            GetExpectedCollectionsToday(
                AsOfDate));
    end;


    procedure GetNetLiquidityPositionAmount(
        AsOfDate: Date): Decimal
    begin
        exit(
            GetNetLiquidityPosition(
                AsOfDate));
    end;


    procedure GetLiquidityRatioAmount(
        AsOfDate: Date): Decimal
    begin
        exit(
            GetLiquidityRatio(
                AsOfDate));
    end;






    // =========================================================
    // POPULATE CASH FLOW FORECAST
    // =========================================================

    procedure PopulateCashFlowForecast(
        FromDate: Date;
        ToDate: Date)
    var
        CashFlowSummary: Record "BOSA Cash Flow Summary";
    begin
        if FromDate = 0D then
            FromDate := WorkDate();

        if ToDate = 0D then
            ToDate := FromDate + 29;

        if ToDate < FromDate then
            Error(
                'The To Date (%1) cannot be earlier than the From Date (%2).',
                ToDate,
                FromDate);

        // Remove previous forecast records for this date.
        CashFlowSummary.Reset();
        CashFlowSummary.SetRange("Date", FromDate);

        if not CashFlowSummary.IsEmpty() then
            CashFlowSummary.DeleteAll();

        // -----------------------------------------------------
        // TODAY
        // -----------------------------------------------------

        InsertCashFlowSummary(
            'Today',
            GetInflows(
                FromDate,
                FromDate),
            GetOutflows(
                FromDate,
                FromDate),
            FromDate);

        // -----------------------------------------------------
        // NEXT 7 DAYS
        // -----------------------------------------------------

        InsertCashFlowSummary(
            '7 Days',
            GetInflows(
                FromDate,
                FromDate + 6),
            GetOutflows(
                FromDate,
                FromDate + 6),
            FromDate);

        // -----------------------------------------------------
        // NEXT 30 DAYS
        // -----------------------------------------------------

        InsertCashFlowSummary(
            '30 Days',
            GetInflows(
                FromDate,
                ToDate),
            GetOutflows(
                FromDate,
                ToDate),
            FromDate);
    end;


    // =========================================================
    // INSERT CASH FLOW SUMMARY
    // =========================================================

    local procedure InsertCashFlowSummary(
        PeriodName: Text[30];
        Inflows: Decimal;
        Outflows: Decimal;
        EntryDate: Date)
    var
        CashFlowSummary: Record "BOSA Cash Flow Summary";
    begin
        CashFlowSummary.Init();

        CashFlowSummary."Period" := PeriodName;
        CashFlowSummary.Inflows := Inflows;
        CashFlowSummary.Outflows := Outflows;

        CashFlowSummary."Net Cash" :=
            Inflows - Outflows;

        CashFlowSummary."Date" :=
            EntryDate;

        CashFlowSummary.Insert(true);
    end;
}