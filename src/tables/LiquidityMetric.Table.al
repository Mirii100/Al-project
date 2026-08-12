table 50101 "Liquidity Metric"
{
    Caption = 'Liquidity Metric';
    DataClassification = CustomerContent;
    DrillDownPageId = "Liquidity Metrics";
    LookupPageId = "Liquidity Metrics";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Metric"; Enum "Liquidity Metric Type")
        {
            Caption = 'Metric';
            DataClassification = CustomerContent;
        }
        field(3; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }
        field(4; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
    }

    // keys
    // {
    //     key(PK; "Entry No.")
    //     {
    //         Clustered = true;
    //     }
    //     key(MetricKey; "Metric")
    //     {
    //     }
    // }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }

        key(MetricDateKey; "Date", "Metric")
        {
        }
    }
}
