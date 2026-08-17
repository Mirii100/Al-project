report 50132 "Aging Analysis Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Aging Analysis Report';
    RDLCLayout = 'src/layouts/AgingAnalysisReport.rdl';

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
