//+------------------------------------------------------------------+
//|                                               Mark Inbalance.mq5 |
//|                                                     KeitumetseCH |
//|                          https://keitumetse.ternitidigital.co.za |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property version   "1.0"
#property indicator_chart_window

//Input variable declaration
input color percLineColor = C'0,255,0'; //Line Colour
input string indicatorMarkPercHotKey = "m"; //Mark Percentage Hotkey
input string indicatorClearHotKey = "c"; //Clear Indicator Data Hotkey
input string indicatorText = "Inbalance"; //Description Text

//global variable declaration
double price1 = 0;
double price2 = 0;
double priceDiff = 0;
datetime time1;
datetime time2;
bool mark = false;
datetime dt;
double price;
int priceCount = 0;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(){
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,const int prev_calculated,const datetime &time[],const double &open[],const double &high[],const double &low[],const double &close[],const long &tick_volume[],const long &volume[],const int &spread[]){
   return(rates_total);
}
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam){
   if(id == CHARTEVENT_KEYDOWN){ // Listen for key press on the chart
      short KeyThatWasPressed = TranslateKey((int)lparam);
      
      if(ShortToString(KeyThatWasPressed) == indicatorMarkPercHotKey){
         mark = true;
      }
      
      if(ShortToString(KeyThatWasPressed) == indicatorClearHotKey){
         mark = false;
         priceCount = 0;
         price1 = 0;
         price2 = 0;
      }
   }
   if(id == CHARTEVENT_CLICK && mark){ // Listen for mouse click on the chart
      int x = (int)lparam;
      int y = (int)dparam;
      double gapSize;
      int window = 0;
      
      if(ChartXYToTimePrice(0,x,y,window,dt,price)){ // Retrieve mouse position on the chart
         if(priceCount == 0){
            price1 = price;
            time1 = dt;
         }
         if(priceCount == 1){
            price2 = price;
            time2 = dt;
         }
         
         if(priceCount == 1){
            priceDiff = price1 - price2;
            gapSize = NormalizeDouble(priceDiff/_Point,0);
            priceDiff = priceDiff / 2;
            priceDiff = price2 + priceDiff;
            ObjectCreate(0,"Inbalance line "+DoubleToString(priceDiff,_Digits),OBJ_FIBO,0,time1,price1,time2,price2);
            ObjectSetInteger(0,"Inbalance line "+DoubleToString(priceDiff,_Digits),OBJPROP_COLOR,percLineColor);
            ObjectSetInteger(0,"Inbalance line "+DoubleToString(priceDiff,_Digits),OBJPROP_LEVELS,1);
            ObjectSetInteger(0,"Inbalance line "+DoubleToString(priceDiff,_Digits),OBJPROP_SELECTABLE,true);
            ObjectSetInteger(0,"Inbalance line "+DoubleToString(priceDiff,_Digits),OBJPROP_RAY_RIGHT,true);
            ObjectSetInteger(0,"Inbalance line "+DoubleToString(priceDiff,_Digits),OBJPROP_HIDDEN,false);
            ObjectSetInteger(0,"Inbalance line "+DoubleToString(priceDiff,_Digits),OBJPROP_BACK,true);
            for(int b=0;b<1;b++){
               ObjectSetDouble(0,"Inbalance line "+DoubleToString(priceDiff,_Digits),OBJPROP_LEVELVALUE,0.5);
               ObjectSetInteger(0,"Inbalance line "+DoubleToString(priceDiff,_Digits),OBJPROP_LEVELCOLOR,percLineColor);
               ObjectSetString(0,"Inbalance line "+DoubleToString(priceDiff,_Digits),OBJPROP_LEVELTEXT,indicatorText+" - "+GetTimeFrame());
               ObjectSetString(0,"Inbalance line "+DoubleToString(priceDiff,_Digits),OBJPROP_TOOLTIP,DoubleToString(fabs(gapSize),0));
            }
            ChartRedraw(0);
            mark = false;
            priceCount = 0;
            price1 = 0;
            price2 = 0;
         }
         if(mark){
            priceCount++;
         }
      }else{
         Print("ChartXYToTimePrice return error code: ",GetLastError());
         Print("+--------------------------------------------------------------+");
      }
   }
}string GetTimeFrame(){
   switch(_Period){
      case 1: return("1 Min");
      case 2: return("2 Min");
      case 3: return("3 Min");
      case 4: return("4 Min");
      case 5: return("5 Min");
      case 6: return("6 Min");
      case 10: return("10 Min");
      case 12: return("12 Min");
      case 15: return("15 Min"); 
      case 30: return("30 Min");
      case 16385: return("1 Hour");
      case 16386: return("2 Hour");
      case 16387: return("3 Hour");
      case 16388: return("4 Hour");
      case 16390: return("6 Hour");
      case 16392: return("8 Hour");
      case 16396: return("12 Hour");
      case 16408: return("Daily");
      case 32769: return("Weekly"); 
      case 49153: return("Monthly");
      default: return("Null");
   }
}
