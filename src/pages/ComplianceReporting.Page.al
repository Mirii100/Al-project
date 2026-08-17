page 50131 "Compliance Reporting"
{
    PageType = List;
    Caption = 'Compliance Reporting';
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
            }
        }
    }
}
