#define GPIO_SWs    0x80001400
#define GPIO_LEDs   0x80001404
#define GPIO_INOUT  0x80001408

#define READ_GPIO(dir) (*(volatile unsigned *)dir)
#define WRITE_GPIO(dir, value) { (*(volatile unsigned *)dir) = (value); }

int main ( void )
{
    unsigned int En_Value=0xFFFF, switches_value, lsb, msb;

    WRITE_GPIO(GPIO_INOUT, En_Value);

    while (1) { 
        switches_value = READ_GPIO(GPIO_SWs);
        switches_value = switches_value >> 16;
        msb = switches_value & 0xF000;
        msb = switches_value >> 12;
        lsb = switches_value & 0x000F;
        if (msb + lsb > 0xf) 
        {
            WRITE_GPIO(GPIO_LEDs, 0x10);
        }
        else 
        {
            WRITE_GPIO(GPIO_LEDs, msb + lsb);
        }
    }

    return(0);
}