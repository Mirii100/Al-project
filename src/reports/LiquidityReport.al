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
            column(Metric; Metric) { }
            column(Amount; Amount) { }
            column(MetricDate; "Date") { }

            trigger OnPreDataItem()
            begin
                SetRange("Date", WorkDate(), WorkDate());
            end;
        }
        dataitem("Cash Flow Forecast Entry"; "Cash Flow Forecast Entry")
        {
            column(Period; Period) { }
            column(Inflows; Inflows) { }
            column(Outflows; Outflows) { }
            column(NetCash; "Net Cash") { }
            column(ForecastDate; "Date") { }

            trigger OnPreDataItem()
            begin
                SetRange("Date", WorkDate(), WorkDate() + 30);
            end;
        }
    }
}
