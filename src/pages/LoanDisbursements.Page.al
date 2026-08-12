page 50114 "Loan Disbursements"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Disbursement";
    Caption = 'Loan Disbursements';

    layout
    {
        area(content)
        {
            repeater(Disbursements)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }

                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                }

                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }

                field(Amount; Rec.Amount)
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