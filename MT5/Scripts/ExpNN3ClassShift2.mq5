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
input int      ExtDepth=7;
input int      ExtDeviation=5;
input int      ExtBackstep=3;
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
    int h=iCustom(Symbol(),Period(),"Examples\\ZigZag",ExtDepth,ExtDeviation,ExtBackstep);
    double zh[],zl[];
    ArrayResize(zh,limit);
    ArrayResize(zl,limit);
    CopyBuffer(h,1,0,limit,zh);
    CopyBuffer(h,2,0,limit,zl);
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
         
         
         double delta1=(his[i-j].high)/norm;
         double delta2=(his[i-j].low)/norm;
         d=d+DoubleToString(delta1,8)+" "+DoubleToString(delta2,8)+" ";
      }
      string d1="|labels 0:1";
      if(zh[i]>0) d1="|labels 1:1";
      if(zl[i]>0) d1="|labels 2:1";
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
          
         double delta1=(his[i-j].high)/norm;
         double delta2=(his[i-j].low)/norm;
         d=d+DoubleToString(delta1,8)+" "+DoubleToString(delta2,8)+" ";
      }
      string d1="|labels 0:1";
      if(zh[i]>0) d1="|labels 1:1";
      if(zl[i]>0) d1="|labels 2:1";
      d=d+d1;
      FileWrite(ot,d);
    }
    FileClose(ot);
  }
//+------------------------------------------------------------------+
