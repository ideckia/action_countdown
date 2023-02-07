# Action for [ideckia](https://ideckia.github.io/): countdown

## Description

Countdown timer.

Sound from: https://soundbible.com/1766-Fire-Pager.html

## Properties

| Name | Type | Description | Shared | Default | Possible values |
| ----- |----- | ----- | ----- | ----- | ----- |
| initial_time | String | Initial time for the countdown. The unit is definde with the value (s or m). If no unit is provided, default is seconds. Examples: 3s, 15m. | false | "25m" | null |
| add_time | String | Add this time to the countdown when longpress the button while the timer is running. | false | "5m" | null |
| sound_path | String | Sound to play when countdown is over. | false | null | null |

## On single click

Starts / pauses the timer

## On long press

If the timer is running when long pressed, it will add `props.add_time` time to the timer. If the timer is paused when long pressed, it will reset to `props.initial_time`.

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
                    "initial_time": "25m",
                    "add_time": "5m",
                    "sound_path": "/path/to/sound.wav"
            }
        }
    ]
}
```
