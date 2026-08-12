page 50113 "Liquidity Metrics"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Liquidity Metric";
    Caption = 'Liquidity Metrics';

    layout
    {
        area(content)
        {
            repeater(Metrics)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }

                field(Metric; Rec.Metric)
                {
                    ApplicationArea = All;
                }

                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }

                field("Date"; Rec."Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}