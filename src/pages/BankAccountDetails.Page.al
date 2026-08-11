page 50124 "Bank Account Details"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Bank Account Details';
    SourceTable = "Bank Account Detail";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; "No.") { }
                field("Name"; Name) { }
                field("Balance"; Balance) { }
                field("As Of Date"; "As Of Date") { }
                field("Currency Code"; "Currency Code") { }
            }
        }
    }
}
