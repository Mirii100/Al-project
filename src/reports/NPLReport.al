report 50131 "NPL Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'NPL Report';
    RDLCLayout = 'src/layouts/NPLReport.rdl';

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
