table 50106 "Loan"
{
    Caption = 'Loan';
    DataClassification = CustomerContent;
    DrillDownPageId = "Loans";
    LookupPageId = "Loans";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
        }
        field(3; "Loan Amount"; Decimal)
        {
            Caption = 'Loan Amount';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }
        field(4; "Outstanding Amount"; Decimal)
        {
            Caption = 'Outstanding Amount';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(5; "Disbursement Date"; Date)
        {
            Caption = 'Disbursement Date';
            DataClassification = CustomerContent;
        }
        field(6; "Status"; Option)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            OptionMembers = Open,Active,Closed,Cancelled;
            OptionCaption = 'Open,Active,Closed,Cancelled';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key("Customer No."; "Customer No.")
        {
        }
    }
}
