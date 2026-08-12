page 50116 "Bank Account Details"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Bank Account Detail";
    Caption = 'Bank Account Details';

    layout
    {
        area(content)
        {
            repeater(BankAccounts)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }

                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }

                field(Balance; Rec.Balance)
                {
                    ApplicationArea = All;
                }

                field("As Of Date"; Rec."As Of Date")
                {
                    ApplicationArea = All;
                }

                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}