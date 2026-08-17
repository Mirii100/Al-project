page 50121 "Board Dashboard"
{
    PageType = RoleCenter;
    Caption = 'Board Dashboard';

    layout
    {
        area(RoleCenter)
        {
            group(Overview)
            {
                Caption = 'Strategic Indicators';
                part("Board Cues Part"; "Liquidity Metrics")
                {
                    ApplicationArea = All;
                }
            }
            group(Analytics)
            {
                Caption = 'Strategic Performance Visuals';
                part("Portfolio Growth"; "Liquidity Metrics")
                {
                    ApplicationArea = All;
                    Caption = 'Portfolio Growth Trend (12 Months)';
                }
            }
        }
    }
}
