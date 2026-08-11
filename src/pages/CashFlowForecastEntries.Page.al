page 50121 "Cash Flow Forecast Entries"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Cash Flow Forecast Entries';
    SourceTable = "Cash Flow Forecast Entry";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; "Entry No.") { }
                field("Period"; "Period") { }
                field("Inflows"; "Inflows") { }
                field("Outflows"; "Outflows") { }
                field("Net Cash"; "Net Cash") { }
                field("Date"; "Date") { }
            }
        }
    }
}
