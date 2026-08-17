codeunit 50131 "NPL Report Mgt"
{
    procedure GetTotalNPL(): Decimal
    var
        // Logic will depend on Loan status or aging
        Loan: Record "Loan";
    begin
        // Placeholder: Needs NPL definition (e.g., status or past due days)
        exit(0);
    end;

    procedure GetNPLRatio(): Decimal
    begin
        // Placeholder
        exit(0);
    end;
}
