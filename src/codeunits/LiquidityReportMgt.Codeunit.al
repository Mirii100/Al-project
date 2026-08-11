codeunit 50111 "Liquidity Report Mgt."
{
    procedure PopulateLiquidityMetrics(AsOfDate: Date)
    var
        LiquidityMetric: Record "Liquidity Metric";
    begin
        LiquidityMetric.SetRange("Date", AsOfDate);
        if LiquidityMetric.HasFilter() then
            LiquidityMetric.DeleteAll();

        InsertLiquidityMetric(Enum::"Liquidity Metric Type"::"Cash at Bank", GetCashAtBank(AsOfDate), AsOfDate);
        InsertLiquidityMetric(Enum::"Liquidity Metric Type"::"Cash on Hand", GetCashOnHand(AsOfDate), AsOfDate);
        InsertLiquidityMetric(Enum::"Liquidity Metric Type"::"Total Liquid Assets", GetTotalLiquidAssets(AsOfDate), AsOfDate);
        InsertLiquidityMetric(Enum::"Liquidity Metric Type"::"Expected Loan Disbursements", GetExpectedLoanDisbursements(AsOfDate), AsOfDate);
        InsertLiquidityMetric(Enum::"Liquidity Metric Type"::"Expected Collections Today", GetExpectedCollectionsToday(AsOfDate), AsOfDate);
        InsertLiquidityMetric(Enum::"Liquidity Metric Type"::"Net Liquidity Position", GetNetLiquidityPosition(AsOfDate), AsOfDate);
        InsertLiquidityMetric(Enum::"Liquidity Metric Type"::"Liquidity Ratio", GetLiquidityRatio(AsOfDate), AsOfDate);
    end;

    procedure PopulateCashFlowForecast(FromDate: Date; ToDate: Date)
    var
        CashFlowEntry: Record "Cash Flow Forecast Entry";
    begin
        CashFlowEntry.SetRange("Date", FromDate, ToDate);
        if CashFlowEntry.HasFilter() then
            CashFlowEntry.DeleteAll();

        InsertCashFlowEntry(Enum::"Cash Flow Period Type"::Today, GetInflows(FromDate, FromDate), GetOutflows(FromDate, FromDate), FromDate);
        InsertCashFlowEntry(Enum::"Cash Flow Period Type"::"7 Days", GetInflows(FromDate, FromDate + 7), GetOutflows(FromDate, FromDate + 7), FromDate);
        InsertCashFlowEntry(Enum::"Cash Flow Period Type"::"30 Days", GetInflows(FromDate, ToDate), GetOutflows(FromDate, ToDate), FromDate);
    end;

    local procedure InsertLiquidityMetric(MetricType: Enum "Liquidity Metric Type"; Amount: Decimal; EntryDate: Date)
    var
        LiquidityMetric: Record "Liquidity Metric";
    begin
        LiquidityMetric.Init();
        LiquidityMetric.Metric := MetricType;
        LiquidityMetric.Amount := Amount;
        LiquidityMetric."Date" := EntryDate;
        LiquidityMetric.Insert(true);
    end;

    local procedure InsertCashFlowEntry(PeriodType: Enum "Cash Flow Period Type"; Inflows: Decimal; Outflows: Decimal; EntryDate: Date)
    var
        CashFlowEntry: Record "Cash Flow Forecast Entry";
    begin
        CashFlowEntry.Init();
        CashFlowEntry.Period := PeriodType;
        CashFlowEntry.Inflows := Inflows;
        CashFlowEntry.Outflows := Outflows;
        CashFlowEntry."Date" := EntryDate;
        CashFlowEntry.Insert(true);
    end;

    local procedure GetCashAtBank(AsOfDate: Date): Decimal
    begin
        exit(GetTotalFromBankAccountDetail(AsOfDate));
    end;

    local procedure GetCashOnHand(AsOfDate: Date): Decimal
    begin
        exit(0);
    end;

    local procedure GetTotalLiquidAssets(AsOfDate: Date): Decimal
    begin
        exit(GetCashAtBank(AsOfDate) + GetCashOnHand(AsOfDate));
    end;

    local procedure GetExpectedLoanDisbursements(AsOfDate: Date): Decimal
    var
        LoanDisbursement: Record "Loan Disbursement";
        Total: Decimal;
    begin
        Total := 0;
        LoanDisbursement.SetRange("Posting Date", AsOfDate);
        LoanDisbursement.SetRange("Status", LoanDisbursement.Status::Pending);
        if LoanDisbursement.FindSet() then
            repeat
                Total += LoanDisbursement.Amount;
            until LoanDisbursement.Next() = 0;
        exit(Total);
    end;

    local procedure GetExpectedCollectionsToday(AsOfDate: Date): Decimal
    begin
        exit(0);
    end;

    local procedure GetNetLiquidityPosition(AsOfDate: Date): Decimal
    begin
        exit(GetTotalLiquidAssets(AsOfDate) + GetExpectedLoanDisbursements(AsOfDate) + GetExpectedCollectionsToday(AsOfDate));
    end;

    local procedure GetLiquidityRatio(AsOfDate: Date): Decimal
    begin
        if GetTotalLiquidAssets(AsOfDate) = 0 then
            exit(0);
        if GetNetLiquidityPosition(AsOfDate) = 0 then
            exit(0);
        exit(GetTotalLiquidAssets(AsOfDate) / abs(GetNetLiquidityPosition(AsOfDate)));
    end;

    local procedure GetInflows(FromDate: Date; ToDate: Date): Decimal
    begin
        exit(0);
    end;

    local procedure GetOutflows(FromDate: Date; ToDate: Date): Decimal
    begin
        exit(0);
    end;

    local procedure GetTotalFromBankAccountDetail(AsOfDate: Date): Decimal
    var
        BankAccountDetail: Record "Bank Account Detail";
        Total: Decimal;
    begin
        Total := 0;
        BankAccountDetail.SetRange("As Of Date", AsOfDate);
        if BankAccountDetail.FindSet() then
            repeat
                Total += BankAccountDetail.Balance;
            until BankAccountDetail.Next() = 0;
        exit(Total);
    end;
}
