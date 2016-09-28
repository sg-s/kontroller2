[![GPL License](http://img.shields.io/badge/license-GPL-blue.svg?style=flat)](http://opensource.org/licenses/GPL-3.0)

# kontroller2
A modern, event-driven hardware I/O controller written around MATLAB's DAQ toolbox. Better than [kontroller](https://github.com/sg-s/kontroller). kontroller2 is currently under active development, and does not work at all. Look at the [kanban](https://github.com/sg-s/kontroller2/projects/1) for an idea of where this project is. 

## Philosophy 

`kontroller2` is being developed with the following design goals in mind: 

### 0. The hardware abstraction layer 

The goal of the original `kontroller` which is even sharper in `kontroller2`, is to act as a hardware abstraction layer, where real devices, valves, lights, sensors and motors appear as black boxes that are directly accessible by software. Thus, every hardware tuning or design problem becomes a numerical optimization problem. The goal is let a computer do things to machines that you would normally do, so that you can throw your favorite brute-force algorithm at the problem and solve it, instead of trying to figure out what's going on. 

### 1. Dual GUI + programmatic interface

Everything in `kontroller2` can be either controlled by a intuitive GUI, or through a programmatic, object-oriented interface. You should be able to do something via the GUI, switch to headless mode, do something via a third-party wrapper, and then switch back to the GUI, and everything should just work. `kontroller2`  achieves this by inheriting from the MATLAB `handle` class. 

### 2. Plugin architecture. 

Almost everything in `kontroller2` is written a plugin. `kontroller2` plugins are simply methods, so extending this is as simple as writing more methods. Because `kontroller2` uses a classdef folder (i.e. `@kontroller2`), installing new plugins is as simple as dropping new .m files into this folder. `kontroller2` does the hard work of figuring out what the plugin is, and using it intelligently. To see the plugins that you have installed, use:

```MATLAB
k = kontroller2;
k.plugins;
```

Plugin architecture make the code highly modular, and almost everything can be ripped out and `kontroller2` will still work. 

### 3. The event loop

`kontroller2` is heavily influenced by the concept of the [event loop](https://en.wikipedia.org/wiki/Event_loop), for example like the one at the heart of [node.js](https://en.wikipedia.org/wiki/Node.js).  


## Requirements 

1. MATLAB
2. A Windows computer
3. A compatible National Instruments DAQ system
4. NI drivers
5. MATLAB's DAQ toolbox

## Installation

The recommended way to install `kontroller2` is to use my package manager:

```matlab
urlwrite('http://srinivas.gs/install.m','install.m'); 
install sg-s/kontroller2
install sg-s/srinivas.gs_mtools
```
if you have [git](http://www.git-scm.com/) installed, you can 

```bash
git clone https://github.com/sg-s/kontroller2
git clone https://github.com/sg-s/srinivas.gs_mtools # kontroller needs this to work
```
and don't forget to add these folders to your `MATLAB path`


## The kontroller2 data structure 

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

`kontroller3` is free software, under the [GPL v3](http://gplv3.fsf.org/). If you use `kontroller3`, please [write to me](http://srinivas.gs/#contact) to properly cite this. 
