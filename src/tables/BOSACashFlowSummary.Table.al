table 50113 "BOSA Cash Flow Summary"
{
    Caption = 'BOSA Cash Flow Summary';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }

        field(2; "Period"; Text[30])
        {
            Caption = 'Period';
            DataClassification = CustomerContent;
        }

        field(3; "Inflows"; Decimal)
        {
            Caption = 'Inflows';
            DataClassification = CustomerContent;
        }

        field(4; "Outflows"; Decimal)
        {
            Caption = 'Outflows';
            DataClassification = CustomerContent;
        }

        field(5; "Net Cash"; Decimal)
        {
            Caption = 'Net Cash';
            DataClassification = CustomerContent;
        }

        field(6; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }

        key(DateKey; "Date", "Period")
        {
        }
    }
}