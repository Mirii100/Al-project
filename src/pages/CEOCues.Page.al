page 50125 "CEO Cues"
{
    PageType = CardPart;
    Caption = 'CEO Cues';

    layout
    {
        area(Content)
        {
            cuegroup(ExecutiveCues)
            {
                Caption = 'Summary';
                field("Gross Loan Portfolio"; GrossLoanPortfolio)
                {
                    ApplicationArea = All;
                    Caption = 'Gross Loan Portfolio';
                }
                field("Active Borrowers"; ActiveBorrowers)
                {
                    ApplicationArea = All;
                    Caption = 'Active Borrowers';
                }
                field("Monthly Disbursements"; MonthlyDisbursements)
                {
                    ApplicationArea = All;
                    Caption = 'Monthly Disbursements';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        CEOMgt: Codeunit "CEO Dashboard Mgt";
    begin
        GrossLoanPortfolio := CEOMgt.GetGrossLoanPortfolio();
        ActiveBorrowers := CEOMgt.GetActiveBorrowers();
        MonthlyDisbursements := CEOMgt.GetMonthlyDisbursements(Today);
    end;

    var
        GrossLoanPortfolio: Decimal;
        ActiveBorrowers: Integer;
        MonthlyDisbursements: Decimal;
}
