// memory-mapped I/O addresses
#define GPIO_SWs    0x80001400
#define GPIO_LEDs   0x80001404
#define GPIO_INOUT  0x80001408

#define DELAY 0x300000

#define READ_GPIO(dir) (*(volatile unsigned *)dir)
#define WRITE_GPIO(dir, value) { (*(volatile unsigned *)dir) = (value); }

int main ( void )
{
    int En_value=0xFFFF, msb, oldmsb;
    unsigned switches_value, negated_value,j,mask,cnt;

    WRITE_GPIO(GPIO_INOUT, En_value);

    oldmsb = 1234;
    while (1)
    {
        switches_value = READ_GPIO(GPIO_SWs);   //Read value on switches
        negated_value = ~switches_value;        //Get the bitwise inversion of that value
        msb = (switches_value >> 31) & 0x01;    //Get msb value
        
        if(msb == oldmsb)
            continue;
        /* Find number of ones */
        cnt=0;
        mask=0x10000;
        for(int i=0; i<16; i++)
        {
            if(negated_value & mask)
                cnt++;
            mask = mask << 1;
        }
        
        /* Transfer negated value from 16 MSB to 16 LSB where LEDs are */
        negated_value = negated_value >> 16;
        
        /* Flash the negated number cnt times */
        for(int i=0; i<cnt; i++)
        {
            WRITE_GPIO(GPIO_LEDs, negated_value);  //Output on LEDs the negated value for 8 times
            
            /* Delay */
            j=0;
            while(j<DELAY)
                j++;
            
            /* Turn off */
            WRITE_GPIO(GPIO_LEDs, 0x0000);

            /* Delay */
            j=0;
            while(j<DELAY)
                j++;
        }

        oldmsb = msb;
    }
    
}