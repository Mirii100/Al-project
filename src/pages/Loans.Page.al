page 50123 "Loans"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Loans';
    SourceTable = "Loan";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; "No.") { }
                field("Customer No."; "Customer No.") { }
                field("Loan Amount"; "Loan Amount") { }
                field("Outstanding Amount"; "Outstanding Amount") { }
                field("Disbursement Date"; "Disbursement Date") { }
                field("Status"; "Status") { }
            }
        }
    }
}
