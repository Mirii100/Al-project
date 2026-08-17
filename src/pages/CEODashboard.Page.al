page 50120 "CEO Dashboard"
{
    PageType = RoleCenter;
    Caption = 'CEO Dashboard';

    layout
    {
        area(RoleCenter)
        {
            group(Overview)
            {
                Caption = 'Executive Overview';
                part("CEO Cues Part"; "CEO Cues")
                {
                    ApplicationArea = All;
                }
            }
            group(Analytics)
            {
                Caption = 'Performance Analytics';
                part("Portfolio Trend"; "Liquidity Metrics")
                {
                    ApplicationArea = All;
                    Caption = 'Portfolio Growth Trend';
                }
            }
        }
    }
}
