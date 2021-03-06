//+------------------------------------------------------------------+
//|                                                      ForexNN.mq5 |
//|                                           Copyright 2017, Рэндом |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Рэндом"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1
//--- plot Sig
#property indicator_label1  "Sig"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrYellow
#property indicator_style1  STYLE_SOLID
#property indicator_width1  3
//--- input parameters
input string   ModelName="D:\\Models\\model.cmf";//Полный путь к моделе
input int      NBars=1000;
input double   norm=10.0;
input double   Signal=0.5;
input double   NoSignal=0.5;
//--- indicator buffers
#import "ForexEval1.dll"
void LoadModel(string s);
void EvalModel(double &inps[],double &inph[],double &inpl[],double &inpv[],double &out[]);
#import

double         SigBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,SigBuffer,INDICATOR_DATA);
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
   PlotIndexSetInteger(0,PLOT_ARROW,159);
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
   if(limit-17>Bars(Symbol(),Period())-17) limit=Bars(Symbol(),Period())-17;
   ArraySetAsSeries(SigBuffer,true);
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);
   ArraySetAsSeries(tick_volume,true);
   for(int i=0;i<limit;i++)
   {
      double ins[10],inh[10],inl[10],inv[10],ot[3];
      for(int j=1;j<11;j++)
      {
         double delta=(high[i+j]/low[i+j]);
         double delta1=(high[i+j]/high[i+j+1]);
         double delta2=(low[i+j]/low[i+j+1]);
         double delta3=((double)(tick_volume[i+j]))/((double)(tick_volume[i+j+1]));
         ins[j-1]=delta;
         inh[j-1]=delta1;
         inl[j-1]=delta2;
         inv[j-1]=delta3;
      }
      EvalModel(ins,inh,inl,inv,ot);
      SigBuffer[i]=0.0;
      if(ot[1]>Signal && ot[0]<NoSignal && ot[2]<NoSignal) SigBuffer[i]=high[i];
      if(ot[2]>Signal && ot[0]<NoSignal && ot[1]<NoSignal) SigBuffer[i]=low[i];
   }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
