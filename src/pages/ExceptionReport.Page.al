page 50130 "Exception Report"
{
    PageType = List;
    Caption = 'Exception Report';
    SourceTable = "Loan"; 
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field("Customer No."; Rec."Customer No.") { ApplicationArea = All; }
                field("Outstanding Amount"; Rec."Outstanding Amount") { ApplicationArea = All; }
            }
        }
    }
}
