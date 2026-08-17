report 50130 "PAR Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'PAR Report';
    RDLCLayout = 'src/layouts/PARReport.rdl';

    dataset
    {
        dataitem(Loan; "Loan")
        {
            column(LoanNo; "No.") { }
            column(OutstandingAmount; "Outstanding Amount") { }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
    }
}
