table 50107 "Bank Account Detail"
{
    Caption = 'Bank Account Detail';
    DataClassification = CustomerContent;
    DrillDownPageId = "Bank Account Details";
    LookupPageId = "Bank Account Details";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2; "Name"; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(3; "Balance"; Decimal)
        {
            Caption = 'Balance';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }
        field(4; "As Of Date"; Date)
        {
            Caption = 'As Of Date';
            DataClassification = CustomerContent;
        }
        field(5; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key("As Of Date"; "As Of Date")
        {
        }
    }
}
