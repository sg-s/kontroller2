# kontroller2
A event-driven hardware I/O controller written around MATLAB's DAQ toolbox. Better than https://github.com/sg-s/kontroller

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

## License 

[![GPL License](http://img.shields.io/badge/license-GPL-blue.svg?style=flat)](http://opensource.org/licenses/GPL-2.0)

[GPL v2](http://choosealicense.com/licenses/gpl-2.0/#)
