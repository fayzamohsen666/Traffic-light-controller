#define u        portb.b2
#define t        portb.b3

#define l1       portb.b4
#define l2       portb.b5

#define dir      portb.b1
#define gr1      portd.b2   // Green W

#define manu     1
#define auto     0

#define south    1
#define west     0

#define OFF      1          // Active low logic
#define ON       0

char mode = 0;
char direction = 0;
char flag = 0;

void display(int wNumber, int sNumber);
void lights(char config);
void automatic();
void handle();
void manual();

void main() {
    ADCON1 = 0x07;        // Digital I/O
    trisb  = 0x03;        // RB0,RB1 input
    trisc  = 0; portc = 0;
    trisd  = 0; portd = 0;

    intedg_bit = 0;
    inte_bit   = 1;
    gie_bit    = 1;

    while (1) {
        if (mode == auto)
            automatic();
        else if (mode == manu)
            manual();
    }
}

// Multiplexed 7-seg display
void display(int wNumber, int sNumber) {
    int wleft  = wNumber / 10;
    int wright = wNumber % 10;
    int sleft  = sNumber / 10;
    int sright = sNumber % 10;
    int j;

    for (j = 0; j < 50; j++) {
        u = ON; t = OFF;
        portc = (sright << 4) | wright;
        delay_ms(5);

        u = OFF; t = ON;
        portc = (sleft << 4) | wleft;
        delay_ms(5);
    }
}

// Traffic light control
void lights(char config) {
    switch (config) {
        case 0: portd = 0b001100; break; // Green W, Red S
        case 1: portd = 0b100001; break; // Green S, Red W
        case 2: portd = 0b001010; break; // Yellow W
        case 3: portd = 0b010001; break; // Yellow S
    }
}

// Automatic traffic sequence
void automatic() {
    int i;
    direction = west;
    l1 = l2 = OFF;

    if (gr1) {
        lights(2); // Yellow W
        for (i = 3; i > 0; i--)
            display(i, 0);
    }

    lights(1);
    for (i = 12; i > 0; i--) {
        if (mode == manu) return;
        display(i + 3, i);
    }

    lights(3);
    for (i = 3; i > 0; i--) {
        if (mode == manu) return;
        display(i, i);
    }

    flag = 1;

    lights(0);
    for (i = 20; i > 0; i--) {
        if (mode == manu) return;
        display(i, i + 3);
    }

    lights(2);
    for (i = 3; i > 0; i--) {
        if (mode == manu) return;
        display(i, i);
    }
}

// Manual traffic sequence
void manual() {
    int i;

    if (flag) {
        flag = 0;
        l1 = 1; l2 = 0;
        portc = 0;
        lights(0);
    } else {
        if (direction == west) {
            l1 = 1; l2 = 0;
            lights(3);
            for (i = 3; i > 0; i--)
                display(0, i);
            lights(0);
        } else {
            l1 = 0; l2 = 1;
            lights(2);
            for (i = 3; i > 0; i--)
                display(i, 0);
            lights(1);
        }
    }

    u = 0; t = 0;
    direction = !direction;

    while (dir == OFF && mode == manu); // Wait in manual mode
}

// External interrupt: toggle mode
void interrupt() {
    if (intf_bit) {
        intf_bit = 0;
        mode = !mode;
    }
}
