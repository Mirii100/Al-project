report 50133 "Top Defaulters Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Top Defaulters Report';
    RDLCLayout = 'src/layouts/TopDefaultersReport.rdl';

    dataset
    {
        dataitem(Loan; "Loan")
        {
            // Assuming Loan table has Customer, Outstanding, etc.
            // Need to filter for defaulters (e.g., status, past due)
            column(LoanNo; "No.") { }
            column(CustomerNo; "Customer No.") { }
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
