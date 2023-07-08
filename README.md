# ethPrice

ethPrice is a simple macOS application that periodically fetches the price of Ethereum and displays it in the macOS menu bar. Built with Swift and SwiftUI, ethPrice uses the CoinGecko API to fetch the latest Etheruem and MATIC token prices and updates them every 20 seconds.

## Features

- Fetch and display the live prices of ETH and MATIC token.
- Switch the display between ETH and MATIC token.
- The task scheduler updates the price every 20 seconds.
- Terminate app function.

## Usage

When started, the app displays the price of ETH by default in the macOS menu bar. Simply click on the price and a dropdown menu will appear.

The dropdown menu allows you to select if you'd like to fetch and display the price for ETH or MATIC token. Selecting either one will update the price displayed in the menu bar. 

A "exit" button is also available in the dropdown to close the application.

## Contribution

As this project is not complex, contributions are more than welcome. Be sure to pull request any changes you'd like to have merged into the project.

## Note

This project open sources the code for educational purposes. It should be used as such and we disclaim any responsibility for the misuse of the CoinGecko API or any other damage the usage of this software may cause.