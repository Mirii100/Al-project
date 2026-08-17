report 50135 "Regulatory Reporting"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Regulatory Reporting';
    RDLCLayout = 'src/layouts/RegulatoryReporting.rdl';

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
