### [changeSliderBounds.m](https://github.com/sg-s/kontroller2/blob/master/changeSliderBounds.m)
changes the bounds of manual control sliders based on text edit fields above or below slider. 
### [configureInputChannels.m](https://github.com/sg-s/kontroller2/blob/master/configureInputChannels.m)
creates UI for configuring input channels
### [configureOutputChannels.m](https://github.com/sg-s/kontroller2/blob/master/configureOutputChannels.m)
creates UI for configuring outputs.
### [dataRouter.m](https://github.com/sg-s/kontroller2/blob/master/dataRouter.m)
dataRouter is a function that routes data from and to 
### [dump2mat.m](https://github.com/sg-s/kontroller2/blob/master/dump2mat.m)
dump2mat reads the dump file (e.g. output.k2) and appends the data there to the data structure in a mat file. 
### [inputChannelsListCallback.m](https://github.com/sg-s/kontroller2/blob/master/inputChannelsListCallback.m)
callback on selecting input channels from the main window
### [inputConfigCallback.m](https://github.com/sg-s/kontroller2/blob/master/inputConfigCallback.m)
callback on configuring input channels
### [kontroller2.m](https://github.com/sg-s/kontroller2/blob/master/kontroller2.m)
event-based wrapper for MATLAB's DAQ toolbox
### [makeKontrollerGUI.m](https://github.com/sg-s/kontroller2/blob/master/makeKontrollerGUI.m)
makes the GUI for kontroller2 when it starts up
### [outputConfigCallback.m](https://github.com/sg-s/kontroller2/blob/master/outputConfigCallback.m)
callback when configuring outputs in the configure outputs UI
### [pollManualControl.m](https://github.com/sg-s/kontroller2/blob/master/pollManualControl.m)
asks the ManualControl tab for states to write to the control buffer
### [quitConfigOutputsCallback.m](https://github.com/sg-s/kontroller2/blob/master/quitConfigOutputsCallback.m)
callback on closing the configure outputs windows. 
### [quitKontroller2Callback.m](https://github.com/sg-s/kontroller2/blob/master/quitKontroller2Callback.m)
callback on attempting to close kontroller2 main windows. 
### [rebuildManualControlUI.m](https://github.com/sg-s/kontroller2/blob/master/rebuildManualControlUI.m)
rebuilds Manual Control Tab
### [reconfigureSession.m](https://github.com/sg-s/kontroller2/blob/master/reconfigureSession.m)
reconfigures the DAQ session every time we add or remove a channel, or change the sampling rate
### [refreshScopes.m](https://github.com/sg-s/kontroller2/blob/master/refreshScopes.m)
plots new data to the scopes by rewriting pre-allocated data on a graph
### [saveCallback.m](https://github.com/sg-s/kontroller2/blob/master/saveCallback.m)
determines which mat file to save data to
### [toggleSaveButton.m](https://github.com/sg-s/kontroller2/blob/master/toggleSaveButton.m)
callback when pressing the "save" button on the manual control tab
### [updateScopes.m](https://github.com/sg-s/kontroller2/blob/master/updateScopes.m)
rebuilds Scopes UI, adding or removing subplots as needed
