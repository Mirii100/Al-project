report 50100 "Liquidity Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Liquidity Report';
    RDLCLayout = 'src/layouts/LiquidityReport.rdl';

    dataset
    {
        dataitem("Liquidity Metric"; "Liquidity Metric")
        {
            column(Metric; Metric)
            {
            }

            column(Amount; Amount)
            {
            }

            column(MetricDate; "Date")
            {
            }

            trigger OnPreDataItem()
            begin
                SetRange("Date", WorkDate(), WorkDate());
            end;
        }
    }
}