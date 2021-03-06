//+------------------------------------------------------------------+
//|                                                        ExpNN.mq5 |
//|                                          Copyright 2017, Рэндом. |
//|                                 http://www.investforum.ru/forum/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Рэндом."
#property link      "http://www.investforum.ru/forum/"
#property version   "1.00"
#property script_show_inputs
//--- input parameters
input int      NBars=50000;
input double   Split=0.98;
input double   norm=1.0;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
    int limit=Bars(Symbol(),Period());
    if(limit>NBars) limit=NBars;
    
    MqlRates his[];
    ArrayResize(his,limit);
    CopyRates(Symbol(),Period(),0,limit,his);
    int tr=(int)(limit*Split);
    int ot=FileOpen("train.txt",FILE_WRITE|FILE_ANSI,0);
    for(int i=16;i<tr;i++)
    {
      string d="|features ";
      for(int j=1;j<16;j++)
      {
         double delta=(his[i-j].high-his[i-j].low)/norm;
         double delta1=(his[i-j].high-his[i-j-1].high)/norm;
         double delta2=(his[i-j].low-his[i-j-1].low)/norm;
         d=d+DoubleToString(delta,8)+" "+DoubleToString(delta1,8)+" "+DoubleToString(delta2,8)+" ";
      }
      string d1="|labels ";
      d1=d1+DoubleToString((his[i].high-his[i-1].high)/norm,8)+" ";
      d1=d1+DoubleToString((his[i].low-his[i-1].low)/norm,8);
      d=d+d1;
      FileWrite(ot,d);
    }
    FileClose(ot);
    ot=FileOpen("test.txt",FILE_WRITE|FILE_ANSI,0);
    for(int i=tr;i<limit;i++)
    {
      string d="|features ";
      for(int j=1;j<16;j++)
      {
         double delta=(his[i-j].high-his[i-j].low)/norm;
         double delta1=(his[i-j].high-his[i-j-1].high)/norm;
         double delta2=(his[i-j].low-his[i-j-1].low)/norm;
         d=d+DoubleToString(delta,8)+" "+DoubleToString(delta1,8)+" "+DoubleToString(delta2,8)+" ";
      }
      string d1="|labels ";
      d1=d1+DoubleToString((his[i].high-his[i-1].high)/norm,8)+" ";
      d1=d1+DoubleToString((his[i].low-his[i-1].low)/norm,8);
      d=d+d1;
      FileWrite(ot,d);
    }
    FileClose(ot);
  }
//+------------------------------------------------------------------+
