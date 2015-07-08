[![GPL License](http://img.shields.io/badge/license-GPL-blue.svg?style=flat)](http://opensource.org/licenses/GPL-2.0)

# kontroller2
A event-driven hardware I/O controller written around MATLAB's DAQ toolbox. Better than [kontroller](https://github.com/sg-s/kontroller). kontroller2 is currently under active development. 

## Features

### Real-time control of analogue digital outputs

### Unlimited data streaming to disk

## Requirements 

1. MATLAB
2. A Windows computer
3. A compatible National Instruments DAQ system
4. NI drivers
5. MATLAB's DAQ toolbox

## Installation

The recommended way to install `kontroller2` is to use my package manager:

```matlab
>> urlwrite('http://srinivas.gs/install.m','install.m'); 
>> install kontroller2
>> install srinivas.gs_mtools
```
if you have [git](http://www.git-scm.com/) installed, you can 

```bash
git clone https://github.com/sg-s/kontroller2
git clone https://github.com/sg-s/srinivas.gs_mtools # kontroller needs this to work
```
and don't forget to add these folders to your `MATLAB path`

## Hacking 

### Data structure 

Saved data is stored in a MAT file in the variable `data`. `data` is a structure with the following fields:
```
* Input1        (dynamically 
* Input2        named based on
* ...           what you configure
* InputN        your input channels)
* paradigm      stores paradigm name, if this comes from a control paradigm 
* trial         stores trial #, if this comes from a control paradigm
* Outputs       stores the actual outputs written during this trial.
```

Each field is a cell array, so, for example:

```
data.voltage{34}     % is a vector that is M samples long
data.Outputs{34}     % a matrix also M samples long
data.trial{34}       % a scalar
```

## License 

[GPL v2](http://choosealicense.com/licenses/gpl-2.0/#)
