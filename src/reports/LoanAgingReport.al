report 50101 "Loan Aging Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Loan Aging Report';
    RDLCLayout = 'src/layouts/LoanAgingReport.rdl';

    dataset
    {
        dataitem(AgingBuffer; "Aging Summary Buffer")
        {
            DataItemTableView = sorting("Entry No.");
            column(Description; Description) { }
            column(NumberOfLoans; "Number of Loans") { }
            column(OutstandingBalance; "Outstanding Balance") { }
            column(PercentPortfolio; "Percent Portfolio") { }
        }
    }

    trigger OnPreReport()
    var
        LoanAgingMgt: Codeunit "Loan Aging Mgt.";
    begin
        LoanAgingMgt.CalculateAging(AgingBuffer);
    end;
}
