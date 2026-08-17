page 50126 "Risk Cues"
{
    PageType = CardPart;
    Caption = 'Risk Cues';

    layout
    {
        area(Content)
        {
            cuegroup(RiskCues)
            {
                Caption = 'Summary';
                field("PAR 30"; PAR30)
                {
                    ApplicationArea = All;
                }
                field("PAR 90"; PAR90)
                {
                    ApplicationArea = All;
                }
                field("NPL Ratio"; NPLRatio)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        RiskMgt: Codeunit "Risk Dashboard Mgt";
    begin
        PAR30 := RiskMgt.GetPAR30();
        PAR90 := RiskMgt.GetPAR90();
        NPLRatio := RiskMgt.GetNPLRatio();
    end;

    var
        PAR30: Decimal;
        PAR90: Decimal;
        NPLRatio: Decimal;
}
