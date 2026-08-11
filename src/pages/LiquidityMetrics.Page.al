page 50120 "Liquidity Metrics"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Liquidity Metrics';
    SourceTable = "Liquidity Metric";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; "Entry No.") { }
                field("Metric"; "Metric") { }
                field("Amount"; "Amount") { }
                field("Date"; "Date") { }
            }
        }
    }
}
