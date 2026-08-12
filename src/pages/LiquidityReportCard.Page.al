page 50110 "Liquidity Report Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Liquidity Report Card';
    PromotedActionCategories = 'New,Process,Report';

    layout
    {
        area(Content)
        {
            part("Liquidity Metrics"; "Liquidity Metrics")
            {
                ApplicationArea = All;
            }
            part("Cash Flow Forecast"; "Cash Flow Forecast Entries")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Populate Data")
            {
                ApplicationArea = All;
                Caption = 'Populate Data';
                Image = Update;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    LiquidityReportMgt: Codeunit "Liquidity Report Mgt.";
                begin
                    LiquidityReportMgt.PopulateLiquidityMetrics(WorkDate());
                    LiquidityReportMgt.PopulateCashFlowForecast(WorkDate(), WorkDate() + 30);
                    Message('Liquidity data has been populated for %1.', WorkDate());
                end;
            }
        }
    }
}
