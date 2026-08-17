codeunit 50130 "PAR Report Mgt"
{
    procedure GetGrossLoanPortfolio(): Decimal
    var
        Loan: Record "Loan";
    begin
        Loan.CalcSums("Outstanding Amount");
        exit(Loan."Outstanding Amount");
    end;

    procedure GetPARAmount(Days: Integer): Decimal
    var
        // Logic will depend on Loan Aging table/buffer
        // Placeholder implementation
        AgingSummary: Record "Aging Summary Buffer";
    begin
        // This would filter the aging buffer or loan ledger
        exit(0);
    end;
}
