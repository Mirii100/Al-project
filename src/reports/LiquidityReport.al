// // report 50100 "Liquidity Report"
// // {
// //     UsageCategory = ReportsAndAnalysis;
// //     ApplicationArea = All;
// //     Caption = 'Liquidity Report';
// //     RDLCLayout = 'src/layouts/LiquidityReport.rdl';

// //     dataset
// //     {
// //         dataitem("Liquidity Metric"; "Liquidity Metric")
// //         {
// //             column(Metric; Metric)
// //             {
// //             }

// //             column(Amount; Amount)
// //             {
// //             }

// //             column(MetricDate; "Date")
// //             {
// //             }

// //             trigger OnPreDataItem()
// //             begin
// //                 SetRange("Date", WorkDate(), WorkDate());
// //             end;
// //         }
// //     }
// // }



// report 50100 "Liquidity Report"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     Caption = 'Liquidity Report';
//     RDLCLayout = 'src/layouts/LiquidityReport.rdl';

//     dataset
//     {
//         dataitem("Liquidity Metric"; "Liquidity Metric")
//         {
//             column(Metric; Metric)
//             {
//             }

//             column(Amount; Amount)
//             {
//             }

//             column(MetricDate; "Date")
//             {
//             }

//             trigger OnPreDataItem()
//             begin
//                 SetRange("Date", WorkDate(), WorkDate());
//             end;
//         }

//         dataitem("Cash Flow Forecast Entry"; "Cash Flow Forecast Entry")
//         {
//             column(EntryNo; "Entry No.")
//             {
//             }

//             column(CashFlowDate; "Cash Flow Date")
//             {
//             }

//             column(AmountLCY; "Amount (LCY)")
//             {
//             }

//             column(Positive; Positive)
//             {
//             }

//             column(SourceType; "Source Type")
//             {
//             }

//             column(CashFlowAccountNo; "Cash Flow Account No.")
//             {
//             }

//             column(Description; Description)
//             {
//             }

//             column(DocumentNo; "Document No.")
//             {
//             }

//             column(SourceNo; "Source No.")
//             {
//             }

//             trigger OnPreDataItem()
//             begin
//                 SetRange("Cash Flow Date", WorkDate(), WorkDate() + 30);
//             end;
//         }
//     }
// }




report 50100 "Liquidity Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Liquidity Report';

    RDLCLayout = 'src/layouts/LiquidityReport.rdl';

    dataset
    {
        dataitem(LiquidityMetric; "Liquidity Metric")
        {
            column(EntryNo; "Entry No.")
            {
            }

            column(Metric; Metric)
            {
            }

            column(Amount; Amount)
            {
            }

            column(MetricDate; "Date")
            {
            }
        }
    }
}