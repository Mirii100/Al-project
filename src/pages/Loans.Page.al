page 50115 "Loans"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan";
    Caption = 'Loans';

    layout
    {
        area(content)
        {
            repeater(Loans)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }

                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }

                field("Loan Amount"; Rec."Loan Amount")
                {
                    ApplicationArea = All;
                }

                field("Outstanding Amount"; Rec."Outstanding Amount")
                {
                    ApplicationArea = All;
                }

                field("Disbursement Date"; Rec."Disbursement Date")
                {
                    ApplicationArea = All;
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}