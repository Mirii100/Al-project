codeunit 50102 "Loan Aging Mgt."
{
    // Encapsulates logic for calculating loan aging buckets.

    procedure CalculateAging(var AgingBuffer: Record "Aging Summary Buffer")
    var
        Loan: Record "Loan";
        TotalBalance: Decimal;
        DaysOld: Integer;
    begin
        // Clear previous calculations
        AgingBuffer.DeleteAll();

        // Calculate Total Outstanding Balance for portfolio percentage
        Loan.CalcSums("Outstanding Amount");
        TotalBalance := Loan."Outstanding Amount";

        // Initialize Buckets
        InitializeBucket(AgingBuffer, 1, '0-30 Days');
        InitializeBucket(AgingBuffer, 2, '31-60 Days');
        InitializeBucket(AgingBuffer, 3, '61-90 Days');
        InitializeBucket(AgingBuffer, 4, '90+ Days');

        // Aggregate Loans
        if Loan.FindSet() then
            repeat
                if Loan."Disbursement Date" = 0D then
                    DaysOld := 0
                else
                    DaysOld := WorkDate() - Loan."Disbursement Date";

                if DaysOld <= 30 then
                    UpdateBucket(AgingBuffer, 1, Loan."Outstanding Amount", TotalBalance)
                else if DaysOld <= 60 then
                    UpdateBucket(AgingBuffer, 2, Loan."Outstanding Amount", TotalBalance)
                else if DaysOld <= 90 then
                    UpdateBucket(AgingBuffer, 3, Loan."Outstanding Amount", TotalBalance)
                else
                    UpdateBucket(AgingBuffer, 4, Loan."Outstanding Amount", TotalBalance);
            until Loan.Next() = 0;
    end;

    local procedure InitializeBucket(var AgingBuffer: Record "Aging Summary Buffer"; EntryNo: Integer; Desc: Text[50])
    begin
        AgingBuffer.Init();
        AgingBuffer."Entry No." := EntryNo;
        AgingBuffer.Description := Desc;
        AgingBuffer."Number of Loans" := 0;
        AgingBuffer."Outstanding Balance" := 0;
        AgingBuffer."Percent Portfolio" := 0;
        AgingBuffer.Insert();
    end;

    local procedure UpdateBucket(var AgingBuffer: Record "Aging Summary Buffer"; EntryNo: Integer; Amount: Decimal; TotalBalance: Decimal)
    begin
        if AgingBuffer.Get(EntryNo) then begin
            AgingBuffer."Number of Loans" += 1;
            AgingBuffer."Outstanding Balance" += Amount;
            if TotalBalance <> 0 then
                AgingBuffer."Percent Portfolio" := (AgingBuffer."Outstanding Balance" / TotalBalance) * 100;
            AgingBuffer.Modify();
        end;
    end;
}
