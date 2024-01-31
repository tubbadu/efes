# Electronics for embedded systems - Group 02

> Gabriele Sanna 324140  
> Giulia Solito 329160  
> Ribaudo Alessandro 283309  
> Rong Zhu 327239  

## Laboratory 5

### Project 1: PWM signal

We needed to program the registers DIVISOR (the 50MHz clock divisor), MAXCNT (the value at which the counter resets itself; MAXCNT+2 is the number of possible duty cycle levels) and REG (the number of duty cycles levels in which the output waveform has to stay high).

We wanted to obtain a frequency $f_{PWM} = 10 kHz$ and a number of duty cycles levels equal to 12.

Since:  
$n_\delta = MAXCNT + 2 \Rightarrow MAXCNT = n_\delta - 2$  
$n_\delta = 12 \Rightarrow MAXCNT = 10$  
$f_{PWM} = \frac{f_{count}}{MAXCNT + 1} \Rightarrow f_{count} = f_{PWM} \cdot (MAXCNT + 1)$  
$f_{count} = 10 kHz \cdot 11 = 110 kHz$  

$DIVISOR = \frac{f_{clock}}{f_{count}} - 1 = 454$

To obtain a DC of $\delta$:  
$\delta = \frac{REG}{MAXCNT + 1} \Rightarrow REG = \delta \cdot (MAXCNT + 1)$

- $REG|_{\delta = 0.2} = 0.2 \cdot 11 = 2.2$
- $REG|_{\delta = 0.5} = 0.5 \cdot 11 = 5.5$
- $REG|_{\delta = 0.8} = 0.8 \cdot 11 = 8.8$

Since the register value had to be an integer, we rounded these values to the closer integer:

- $REG|_{\delta = 0.2} = 2$
- $REG|_{\delta = 0.5} = 6$
- $REG|_{\delta = 0.8} = 9$

Because of limitations on the input settings, we were forced to put a divisor value that is an integer multiple of 16 (to the binary number are added 4 zeros), so we input 448 (`00011100(0000)`).  
Due to this approximation and to the rounding of the REG value, the output values were slightly different from the theoretical ones.

In Table 1 are summarized the measurement results we obtained with the oscilloscope and they are shown in Figure 1, Figure 2 and Figure 3.

Afterwards, we wanted to have 100 possible different DC levels, so we repeated the same procedure with different values of REG, MAXCNT and DIVISOR:

Since:  
$n_\delta = MAXCNT + 2 \Rightarrow MAXCNT = n_\delta - 2$  
$n_\delta = 100 \Rightarrow MAXCNT = 98$  
$f_{PWM} = \frac{f_{count}}{MAXCNT + 1} \Rightarrow f_{count} = f_{PWM} \cdot (MAXCNT + 1)$  
$f_{count} = 10 kHz \cdot 99 = 990 kHz$  

$DIVISOR = \frac{f_{clock}}{f_{count}} - 1 = 50$

To obtain a DC of $\delta$:  
$\delta = \frac{REG}{MAXCNT + 1} \Rightarrow REG = \delta \cdot (MAXCNT + 1)$

- $REG|_{\delta = 0.2} = 0.2 \cdot 99 = 19.8$
- $REG|_{\delta = 0.5} = 0.5 \cdot 99 = 49.5$
- $REG|_{\delta = 0.8} = 0.8 \cdot 99 = 79.2$

Since the register value had to be an integer, we rounded these values to the closer integer:

- $REG|_{\delta = 0.2} = 20$
- $REG|_{\delta = 0.5} = 50$
- $REG|_{\delta = 0.8} = 79$

Because of limitations on the input settings, we were forced to put a divisor value that is an integer multiple of 16 (to the binary number are added 4 zeros), so we input 48 (`00000011(0000)`).  
Due to this approximation and to the rounding of the REG value, the output values were slightly different from the theoretical ones.

In Table 2 are summarized the measurement results we obtained with the oscilloscope and they are shown in Figure 4, Figure 5 and Figure 6.

As we expected the output waveform matches the theoretical values, with only small differences due to approximation as explained above, therefore the PWM signal is correct.

|     | ideal DC | REG | $f_{PWM}$ | $t_{on}$   | $t_{off}$  | $\delta$ | $V_H$ | $V_L$ |
| --- | -------- | --- | --------- | ---------- | ---------- | -------- | ----- | ----- |
| C   | 20%      | 2   | 10 kHz    | 18 $\mu s$ | 82 $\mu s$ | 18.18%   | 3.3 V | 0 V   |
| M   | 20%      | 2   | 10.1 kHz  | 18 $\mu s$ | 82 $\mu s$ | 18.18%   | 3.3 V | 40 mV |
| C   | 50%      | 6   | 10 kHz    | 55 $\mu s$ | 45 $\mu s$ | 54.54%   | 3.3 V | 0 V   |
| M   | 50%      | 6   | 10.1 kHz  | 54 $\mu s$ | 46 $\mu s$ | 54.54%   | 3.3 V | 40 mV |
| C   | 80%      | 9   | 10 kHz    | 82 $\mu s$ | 18 $\mu s$ | 81.82%   | 3.3 V | 0 V   |
| M   | 80%      | 9   | 10.1 kHz  | 81 $\mu s$ | 19 $\mu s$ | 81.82%   | 3.3 V | 40 mV |

Table 1: (**C** stands for Computed values, **M** stands for Measured values)

![](report/20DC%20at%2010.jpg)

![](report/20DC%20at%2010.jpg)

![](report/50DC%20at%2010.jpg)

| theoretical DC | REG | $f_{PWM}$ | $t_{on}$ | $t_{off}$    | $\delta$     | $V_H$  | $V_L$ |
| -------------- | --- | --------- | -------- | ------------ | ------------ | ------ | ----- |
| C              | 20% | 20        | 10 kHz   | 20.2 $\mu s$ | 79.8 $\mu s$ | 20.2%  | 3.3 V |
| M              | 20% | 20        | 10.3 kHz | 19 $\mu s$   | 81 $\mu s$   | 19.59% | 3.3 V |
| C              | 50% | 50        | 10 kHz   | 51 $\mu s$   | 49 $\mu s$   | 51%    | 3.3 V |
| M              | 50% | 50        | 10.3 kHz | 49 $\mu s$   | 51 $\mu s$   | 50.5%  | 3.3 V |
| C              | 80% | 79        | 10 kHz   | 81 $\mu s$   | 19 $\mu s$   | 81%    | 3.3 V |
| M              | 80% | 79        | 10.3 kHz | 77 $\mu s$   | 23 $\mu s$   | 79.38% | 3.3 V |

Table 2: (**C** stands for Computed values, **M** stands for Measured values)

![](report/20DC%20at%2098.jpg)
Figure 4: ideal DC = 20%

![](report/50DC%20at%2098.jpg)
Figure 5: ideal DC = 50%

![](report/80DC%20at%2098.jpg)

Figure 6: ideal DC = 80%

## Project 2: driving an external LED with a BJT transistor

Using a 2n3700 npn transistor and a power supply of $V_{cc} = 12 V$, we designed a circuit to switch ON and OFF a 5mm LED.

#### Given parameters:

$V_L = 12 V \\
V_{dd} = 3.3 V \\
f_{PWM} = 10 kHz \\
I_{diode} = I_C = 20 mA$

From the datasheet of the 2N3700:  
$\beta \in (100, 300) \\
V_{CE} = 200 mV \\
V_{BE} = 1.1 V$

To get the diode working voltage we applied 12 V to the diode, using a very big resistor (1 $k\Omega$) in order to be sure not to damage it, and then with the bench DDM we measured it:  
$V_{diode} = 1.96 V$

#### Resistors choice procedure:

We did the calculations using $\beta=100$ (the lower bound) in order to be sure that the base current $I_B$ was enough to turn on the LED.

$V_{R_C} = V_L - V_{CE} - V_{diode} = (12 - 0.2 - 1.96) V = 9.84 V \\
R_C = \frac{V_{R_C}}{I_C} = \frac{9.84 V}{0.02 A} = 492 \Omega \Rightarrow 560 \Omega \\
V_{R_B} = V_{dd} - V_{BE} = (3.3-1.1) V = 2.2 V \\
R_B = \frac{V_{R_B}}{I_B} = \frac{V_{R_B} \cdot \beta}{I_C} = \frac{2.2V \cdot 100}{0.02 A} = 11 k \Omega \Rightarrow 10 k \Omega$

#### Evaluation of power dissipation

$P_{diode} = V_{diode} \cdot I_C = 0.0392 W \\
P_{R_C} = V_{R_C} \cdot I_C = 0.1968 W \\
P_{BJT} = P_{BE} + P_{CE} = V_{BE} \cdot I_B + V_{CE} \cdot I_C = V_{BE} \cdot \frac{V_{R_B}}{R_B} + V_{CE} \cdot I_C = 0.0042 W \\
P_{R_B} = \frac{V_{R_B}^2}{R_B} = 0.0005 W$

Since all resistors power consumption was less than 0.25 W, we could use standard 0.25W resistors. The power consumption of the BJT was also below the maximum values written in the datasheet ($P_{{BJT}_{MAX}} = 0.5 W$, $I_{C_{MAX}} = 0.6 A$)

#### Experiment results

We applied different duty cycles to the base of the BJT: as expected, the LED turned on with different brightness, linearly dependent on the value of the DC applied.

#### Measured values:

$V_{CE_{cutoff}} = 10.4 V \\
V_{CE_{saturation}} = 14 mV \\
V_H = 3.3 V \\
V_L = 0.22 mV$

## Project 3: Transistor delays

With an oscilloscope we measured the falling and rising time of the PWM waveform at the input of the transistor, as shown in the pictures below (Figure 7 and Figure 8). The results are:

$t_{rising} = 9.2 ns \\
t_{falling} = 8 ns$

Secondly, we measured the delay between the PWM output rising transition and the BJT output falling transition and the one between the PWM output falling transition and the BJT output rising transition. The second delay is bigger than the first one, due to the fact that switching OFF a transistor from saturation takes longer because there are charges to remove.

We then added a diode between base and collector to improve performances, and the new delay we measured was:

$t_d = 1.103 \mu s$

The delay is now smaller because the Schottky diode between base and collector avoids saturating the BC junction.

At the end we added a capacitor of 100 nF in parallel to $R_B$ and removed the diode, and we repeated the measurement:

$t_d = 0.292 \mu s$

This is by far the better result we obtained and was obtained by reducing the base resistor using a parallel capacitor that during transients acts as a short circuit and the rest of the time acts as an open circuit.

![](report/ex%203%20-%20falling.jpg)

Figure 7: Rising time of the PWM

![](report/ex%203%20-%20rising.jpg)

Figure 8:  Falling time of the PWM

## Project 5: Different FPGA pin drive strengths

We drove the transistor using three different pins (2, 4 and 6) setting the duty cycle to 100% so that the transistor is permanently in saturation region and we obtained slightly different measurements of $V_{CE_{sat}}$ and $V_H$ caused by the different output currents of the pins. 

The measured values are the following:

GPIO0[1]:  
$V_{CE_{sat}} = 14.199 mV \\
V_H = 3.304 V$

GPIO0[3]:  
$V_{CE_{sat}} = 14.202 mV \\
V_H = 3.302 V$

GPIO0[5]:   
$V_{CE_{sat}} = 14.22 mV \\
V_H = 3.296 V$