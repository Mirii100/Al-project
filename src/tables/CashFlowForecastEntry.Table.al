table 50103 "Cash Flow Forecast Entry"
{
    Caption = 'Cash Flow Forecast Entry';
    DataClassification = CustomerContent;
    DrillDownPageId = "Cash Flow Forecast Entries";
    LookupPageId = "Cash Flow Forecast Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Period"; Enum "Cash Flow Period Type")
        {
            Caption = 'Period';
            DataClassification = CustomerContent;
        }
        field(3; "Inflows"; Decimal)
        {
            Caption = 'Inflows';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }
        field(4; "Outflows"; Decimal)
        {
            Caption = 'Outflows';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }
        field(5; "Net Cash"; Decimal)
        {
            Caption = 'Net Cash';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            Editable = false;
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
        key(PeriodKey; "Period")
        {
        }
        key(DateKey; "Date")
        {
        }
    }

    trigger OnInsert()
    begin
        "Net Cash" := Inflows - Outflows;
    end;

    trigger OnModify()
    begin
        "Net Cash" := Inflows - Outflows;
    end;
}
