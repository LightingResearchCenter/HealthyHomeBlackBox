# HealthyHomeBlackBox

## Examples

There are two example scripts provided for your convienance. These scripts are ***EXAMPLEsimulatedData*** and ***EXAMPLEstaticData***. Both examples make use of supporting functions located in the **excludes** subdirectory.

### EXAMPLEsimulatedData

The first example simulates multiple data collections and treatment calculations. Data files are stored to and read from the user's temporary directory, see also ***tempname*** and ***tempdir***. When the script ends gracefully the user will be given the opportunity to either delete the data files or save them to a different directory. Parameters that control the simulation can be set within the example script under the `Set constants` section. When the script is run a figure is displayed that updates on each loop. Clicking on the red stop button in the figure will gracefully end the example script. The *Simulated Input* plot displays the last 10 days of simulated circadian stimulus and activity index that is used as input to the system. The *Recommended Lighting Schedule* is a graphical display of the calculated treatment schedule. The *Actual Lighting Schedule* is a demonstration of the Swedish Healthy Home Hub might intrerpret the recommended schedule when things like a work schedule are taken into account.

### EXAMPLEstaticData

The second example demonstrates how to run the blackbox against a set of statically defined inputs and provides the expected reference results. All data files for this example are stored in the **testData** subdirectory.

| File Name | Access | Purpose |
| --------- | ------ | ------- |
| activityReading.csv | read only | Example activity reading input file. |
| lightReading.csv | read only | Example light reading input file. |
| pacemaker.csv | read and append | A template to save your results to. Delete your results before running the script a second time. |
| reference_pacemaker.csv | read only | This is the expected results. Your pacemaker.csv for the example inputs should match these results |

In addition to the data files you should inspect your *treatment* structure and compare its values to the *reference_treatment* structure, these values should match.

## Converting to C

### Defines

All functions in the **defines** subdirectory assign static values to parameters. These functions should be replaced with a `#define` in your C code as appropriate.

### Excludes

Functions in the **excludes** subdirectory should not be converted to C. These functions either only exist to support the examples or are for file IO.

### Wrapper

The function ***wrapper*** serves as an example for how the blackbox might be abstracted and how to format inputs and outputs. Some of this code can be converted to C while some components need to be replaced with native C functions.

### Blackbox

The function ***blackbox*** is the core function that integrates all other subfunctions. It is designed to be fully converted to C along with all subfunctions.
