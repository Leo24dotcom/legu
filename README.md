# League Library

A League of Legends library containing information about champions, skins and items in the current version of the game.

|Champion Select|Champion Detail|Skin Gallery|Item Shop|
| --------------|---------------|------------|---------|
|<img width="250" height="400" alt="Screenshot 2026-07-30 at 4 45 19 PM" src="https://github.com/user-attachments/assets/1c9a3199-b53a-484f-a6c6-5c15b8fe9c29" />| <img width="250" height="400" alt="Screenshot 2026-07-30 at 5 02 16 PM" src="https://github.com/user-attachments/assets/3d190b4a-8b6d-4b0d-a7b1-31ef47481a26" />|<img width="250" height="400" alt="Screenshot 2026-07-30 at 5 08 01 PM" src="https://github.com/user-attachments/assets/ac25b3b4-1620-4d99-9517-11463b6106c0" />| <img width="250" height="400" alt="Screenshot 2026-07-30 at 5 09 08 PM" src="https://github.com/user-attachments/assets/1fb83518-cacf-4d65-8536-ba8a8804de6e" />|

<br>

Team Size: Me(1)
<br>

Development Period: 7/23/26-7/30/26 1 week
<br>

Development Environment:
<br>

|Framework|Architecture|
|---------|------------|
|Flutter|MVVM|

<br>

Core Features
<br>

- List of every champion in the game
- Detail screen containing lore and ability descriptions
- List of every skin for said champion
- List of every item and their stats and abilities

<br>

Troubleshooting
- Clicking on champion cards calling api every time causing slower loading times
- Situation
  - Clicking on an individual champion card called both loadlore and lordabilities everytime even if flutter cached the details
- Solution
  - Implemented a check on the main api call that checked if said data was already loaded



