table 50109 "Aging Summary Buffer"
{
    TableType = Temporary;
    Caption = 'Aging Summary Buffer';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Description"; Text[50])
        {
            Caption = 'Description';
        }
        field(3; "Number of Loans"; Integer)
        {
            Caption = 'Number of Loans';
        }
        field(4; "Outstanding Balance"; Decimal)
        {
            Caption = 'Outstanding Balance';
        }
        field(5; "Percent Portfolio"; Decimal)
        {
            Caption = '% Portfolio';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
