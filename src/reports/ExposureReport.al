report 50134 "Exposure Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Exposure by Customer / Employer / Sector Report';
    RDLCLayout = 'src/layouts/ExposureReport.rdl';

    dataset
    {
        dataitem(Loan; "Loan")
        {
            // Placeholder for data grouping by Customer/Employer/Sector
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
