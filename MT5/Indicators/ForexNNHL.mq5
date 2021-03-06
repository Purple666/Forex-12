//+------------------------------------------------------------------+
//|                                                    ForexNNHL.mq5 |
//|                                           Copyright 2017, Рэндом |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Рэндом"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   2
//--- plot H
#property indicator_label1  "H"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot L
#property indicator_label2  "L"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1

input string   ModelName="D:\\Models\\model.cmf";//Полный путь к моделе
input int      NBars=1000;
input double   norm=1.0;

#import "ForexEvalHL.dll"
void LoadModel(string s);
void EvalModel(double &inp[], double &out[]);
#import
//--- indicator buffers
double         HBuffer[];
double         LBuffer[];

double in[45],ot[2];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,HBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,LBuffer,INDICATOR_DATA);
   string s=ModelName;
   LoadModel(s);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   int limit=NBars;
   if(limit-17>Bars(Symbol(),Period())-17) limit=Bars(Symbol(),Period());
   ArraySetAsSeries(HBuffer,true);
   ArraySetAsSeries(LBuffer,true);
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);
   for(int i=0;i<limit;i++)
   {
      int index=0;
      for(int j=1;j<16;j++)
      {
         double delta=(high[i+j]-low[i+j])/norm;
         double delta1=(high[i+j]-high[i+j+1])/norm;
         double delta2=(low[i+j]-low[i+j+1])/norm;
         in[index]=delta;
         in[index+1]=delta1;
         in[index+2]=delta2;
         index=index+3;
      }
      EvalModel(in,ot);
      HBuffer[i]=high[i+1]+ot[0]*norm;
      LBuffer[i]=low[i+1]+ot[1]*norm;
      
   }
   Comment("\n\n\nДлинна бара: ",(HBuffer[0]-LBuffer[0])/Point());
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
