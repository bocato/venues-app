# General Information

This app gets place data from Foursquare API to show nearby venues based on the user's location.
It also provides the possibility to change the radius to be searched.

## Environment setup
Since this project uses [SwiftLint](https://github.com/realm/SwiftLint), [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) and [Swiftgen](https://github.com/SwiftGen/SwiftGen), you need to install those dependencies on your machine to use it properly. To do that, run `make environment` from the project's root folder.

# Makefile commands
- `make clean`: cleans iOS derived data.
- `make environment`: Installs the project dependencies
- `make update_strings`: Updates the SwiftGen generated code for the Localizable.strings files
- `make code_beautify`: runs SwiftFormat and SwiftLint to keep the code in shape based on it's linting and formatting definitions
