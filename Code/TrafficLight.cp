#line 1 "C:/Users/fayza/Desktop/TrafficLight/Final/Traffic-light-controller/Code/TrafficLight.c"
#line 19 "C:/Users/fayza/Desktop/TrafficLight/Final/Traffic-light-controller/Code/TrafficLight.c"
char mode = 0;
char direction = 0;
char flag = 0;

void display(int wNumber, int sNumber);
void lights(char config);
void automatic();
void handle();
void manual();

void main() {
 ADCON1 = 0x07;
 trisb = 0x03;
 trisc = 0; portc = 0;
 trisd = 0; portd = 0;

 intedg_bit = 0;
 inte_bit = 1;
 gie_bit = 1;

 while (1) {
 if (mode ==  0 )
 automatic();
 else if (mode ==  1 )
 manual();
 }
}


void display(int wNumber, int sNumber) {
 int wleft = wNumber / 10;
 int wright = wNumber % 10;
 int sleft = sNumber / 10;
 int sright = sNumber % 10;
 int j;

 for (j = 0; j < 50; j++) {
  portb.b2  =  0 ;  portb.b3  =  1 ;
 portc = (sright << 4) | wright;
 delay_ms(5);

  portb.b2  =  1 ;  portb.b3  =  0 ;
 portc = (sleft << 4) | wleft;
 delay_ms(5);
 }
}


void lights(char config) {
 switch (config) {
 case 0: portd = 0b001100; break;
 case 1: portd = 0b100001; break;
 case 2: portd = 0b001010; break;
 case 3: portd = 0b010001; break;
 }
}


void automatic() {
 int i;
 direction =  0 ;
  portb.b4  =  portb.b5  =  1 ;

 if ( portd.b2 ) {
 lights(2);
 for (i = 3; i > 0; i--)
 display(i, 0);
 }

 flag = 0;

 lights(1);
 for (i = 12; i > 0; i--) {
 if (mode ==  1 ) return;
 display(i + 3, i);
 }

 lights(3);
 for (i = 3; i > 0; i--) {
 if (mode ==  1 ) return;
 display(i, i);
 }

 flag = 1;

 lights(0);
 for (i = 20; i > 0; i--) {
 if (mode ==  1 ) return;
 display(i, i + 3);
 }

 lights(2);
 for (i = 3; i > 0; i--) {
 if (mode ==  1 ) return;
 display(i, i);
 }
}


void manual() {
 int i;

 if (flag) {
 flag = 0;
  portb.b4  = 1;  portb.b5  = 0;
 portc = 0;
 lights(0);
 } else {
 if (direction ==  0 ) {
  portb.b4  = 1;  portb.b5  = 0;
 lights(3);
 for (i = 3; i > 0; i--)
 display(0, i);
 lights(0);
 } else {
  portb.b4  = 0;  portb.b5  = 1;
 lights(2);
 for (i = 3; i > 0; i--)
 display(i, 0);
 lights(1);
 }
 }

  portb.b2  = 0;  portb.b3  = 0;
 direction = !direction;

 while ( portb.b1  ==  1  && mode ==  1 );
}


void interrupt() {
 if (intf_bit) {
 intf_bit = 0;
 mode = !mode;
 }
}
