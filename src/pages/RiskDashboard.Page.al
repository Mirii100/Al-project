page 50122 "Risk Dashboard"
{
    PageType = RoleCenter;
    Caption = 'Risk Dashboard';

    layout
    {
        area(RoleCenter)
        {
            group(Overview)
            {
                Caption = 'Credit Risk Metrics';
                part("Risk Cues Part"; "Risk Cues")
                {
                    ApplicationArea = All;
                }
            }
            group(Analytics)
            {
                Caption = 'Risk Performance Visuals';
                part("Risk Heat Map"; "Liquidity Metrics")
                {
                    ApplicationArea = All;
                    Caption = 'Risk Exposure Heat Map';
                }
            }
        }
    }
}
