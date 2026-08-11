page 50122 "Loan Disbursements"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Loan Disbursements';
    SourceTable = "Loan Disbursement";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; "No.") { }
                field("Loan No."; "Loan No.") { }
                field("Posting Date"; "Posting Date") { }
                field("Amount"; "Amount") { }
                field("Status"; "Status") { }
            }
        }
    }
}
