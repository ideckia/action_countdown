# Action for [ideckia](https://ideckia.github.io/): countdown

## Description

Countdown timer




As mentioned before, this uses the custom Countdown Timer plugin. Press the button once and it starts counting down with a little automation. Press within 1.5s and it ads 5 minutes. Press it again and it stops. Press it again within 1.5s and it resets. 


https://www.npmjs.com/package/audic
https://www.npmjs.com/package/@richienb/vlc
https://www.npmjs.com/package/vlc-static




Sound from: https://soundbible.com/1766-Fire-Pager.html

## Properties

| Name | Type | Description | Shared | Default | Possible values |
| ----- |----- | ----- | ----- | ----- | ----- |
| propertyName | String | Property description | false | "default_value" | ["possible", "values", "for the property"] |

## On single click

TODO

## On long press

TODO

## Test the action

There is a script called `test_action.js` to test the new action. Set the `props` variable in the script with the properties you want and run this command:

```
node test_action.js
```

## Example in layout file

```json
{
    "text": "countdown example",
    "bgColor": "00ff00",
    "actions": [
        {
            "name": "countdown",
            "props": {
                "propertyName": "possible"
            }
        }
    ]
}
```
