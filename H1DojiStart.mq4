extern int MagicNumber=10001;
extern double Lots =0.1;
extern double StopLoss=50;
extern double TakeProfit=50;
extern int Slippage=3;
extern double ratio=1/3;
extern double tprofit=2;
datetime NewTime=0;

int start()
{
  double MyPoint=Point;
  if(Digits==3 || Digits==5) MyPoint=Point*10;
  
  double SL=0;
  double TP=0;

  if( TotalOrdersCount()==0 ) 
  {
     int result=0;
     if((NewTime!=Time[0])&&(High[1]-Open[1]<ratio*(Open[1]-Low[1]))&&(Close[1]>Open[1])&&(Close[1]>iMA(NULL,0,20,0,MODE_EMA,PRICE_CLOSE,1))&&(Close[1]>iMA(NULL,0,60,0,MODE_EMA,PRICE_CLOSE,1))) // Here is your open buy rule
     {
        result=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,0,MagicNumber,0,Blue);
        NewTime=Time[0];
        if(result>0)
        {
         SL=0;
         TP=0;
         if(TakeProfit>0) TP=Ask+tprofit*(Close[1]-Low[1]);
         if(StopLoss>0) SL=Low[1]-2*MyPoint;
         OrderSelect(result,SELECT_BY_TICKET);
         OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(SL,Digits),NormalizeDouble(TP,Digits),0,Green);
        }
        return(0);
     }
     if((NewTime!=Time[0])&&(Open[1]-Close[1]<ratio*(High[1]-Open[1]))&&(Close[1]>Open[1])&&(Close[1]>iMA(NULL,0,20,0,MODE_EMA,PRICE_CLOSE,1))&&(Close[1]>iMA(NULL,0,60,0,MODE_EMA,PRICE_CLOSE,1))) // Here is your open Sell rule
     {
        result=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,0,MagicNumber,0,Red);
        if(result>0)
        {
         NewTime=Time[0];
         SL=0;
         TP=0;
         if(TakeProfit>0) TP=Bid-tprofit*(High[1]-Close[1]);
         if(StopLoss>0) SL=High[1]+2*MyPoint;
         OrderSelect(result,SELECT_BY_TICKET);
         OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(SL,Digits),NormalizeDouble(TP,Digits),0,Green);
        }
        return(0);
     }
  }
}

int TotalOrdersCount()
{
  int result=0;
  for(int i=0;i<OrdersTotal();i++)
  {
     OrderSelect(i,SELECT_BY_POS ,MODE_TRADES);
     if (OrderMagicNumber()==MagicNumber) result++;

   }
  return (result);
}