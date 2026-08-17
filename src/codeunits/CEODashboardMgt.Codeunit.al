codeunit 50120 "CEO Dashboard Mgt"
{
    procedure GetGrossLoanPortfolio(): Decimal
    var
        Loan: Record "Loan";
    begin
        Loan.CalcSums("Outstanding Amount");
        exit(Loan."Outstanding Amount");
    end;

    procedure GetActiveBorrowers(): Integer
    var
        Loan: Record "Loan";
    begin
        Loan.SetRange(Status, Loan.Status::Active);
        exit(Loan.Count);
    end;

    procedure GetMonthlyDisbursements(PostingDate: Date): Decimal
    var
        LoanDisbursement: Record "Loan Disbursement";
    begin
        LoanDisbursement.SetRange("Posting Date", CalcDate('CM', PostingDate), PostingDate); // Simplified for current month
        LoanDisbursement.CalcSums(Amount);
        exit(LoanDisbursement.Amount);
    end;
}
