table 50102 "Loan Disbursement"
{
    Caption = 'Loan Disbursement';
    DataClassification = CustomerContent;
    DrillDownPageId = "Loan Disbursements";
    LookupPageId = "Loan Disbursements";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2; "Loan No."; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(4; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }
        field(5; "Status"; Option)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            OptionMembers = Pending,Posted,Cancelled;
            OptionCaption = 'Pending,Posted,Cancelled';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key("Loan No."; "Loan No.")
        {
        }
        key("Posting Date"; "Posting Date")
        {
        }
    }
}
