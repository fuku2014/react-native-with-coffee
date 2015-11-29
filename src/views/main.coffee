React = require 'react-native'
{StyleSheet, Text, View} = React

MainView = React.createClass
  render: ->
    <View style={styles.container}>
      <Text style={styles.welcome}>
        Welcome to React Native!!
      </Text>
      <Text style={styles.instructions}>
        To get started, edit index.ios.coffee{'\n'}
        Press Cmd+R to test{@props.myCustomProp}
      </Text>
    </View>

styles = StyleSheet.create
  container:
    flex: 1
    justifyContent: 'center'
    alignItems: 'center'
    backgroundColor: '#F5FCFF'
  welcome:
    fontSize: 20
    textAlign: 'center'
    color: '#333333'
    margin: 10
  instructions:
    textAlign: 'center'
    color: '#333333'

module.exports = MainView
