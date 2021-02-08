### Bowling code chanllenge

The app is for the [code challenge](task.pdf)

### Stack

* Ruby version 2.7.1
* Ruby on Rails 6.1
* Redis 

### Run locally

1. Make sure required Ruby version is installed.
2. Make sure Redis server is installed and running.
3. Run `bundle install` to install gems.
4. Run `rspec`

### Functionality

The app's API has three endpoints:

1. `GET /` - returns the game status
2. `POST /start` - starts a new game
3. `POST /deliveries` - adds a delivery to the current frame.
   The endpoing eceives pins number in `pins` parameter.

### Game data storage 

The app stores game data in json object. Default storage is Redis, but it is
possible to configure any kind of storage and pass it to game as dependency.
Example:
```
{
  "frames": [[5,5],[0,10],[10,0],...],
  "active": true,
  "bonus": [],
  "current_frame": 5
}
```

#### Properties:

- `frames` - stores array of frames with deliveries
- `active` - shows if game is started
- `bonus` - stores bonus deliveries in case of last frame is a spare or a strike
- `current_frame` - current frame index 

#### Logic

1. When a game is started a new game data object is created and persisted in storage.
2. While new deliveries are being added the app distributes deliveries between frames.
If it is the last frame and not a spare or a strike the game is finished and `active`
   property bocomes `false`. If the last frame is a spare or a strike the app puts pins
   into `bonus` property.
3. When the game status is requested scores for each frames are calculated and included
into game representation. If a frame score is not possible to calculate (for example there
   are not next deliveries for a strike frame), then the score for the frame is `null`
   
#### Example of a game status response

```json
{
  "status": "success",
  "data": {
    "frames": [[0, 10], [5, 5], [1, 1], [2, 2], [8, 2], [0, 0], [5, 2], [4, 0], [6, 1], [10, 0]],
    "active": false,
    "bonus": [10, 5],
    "score": [15, 26, 28, 32, 42, 42, 49, 53, 60, 85]
  }
}
```

Having data for each frame and scores allows to display a game details on a frontend.

### Features

1. Modular structure. 
2. Isolated logic layer with various service objects within game context:
- `Commands::BuildGameSchema` - build default game schema on start
- `Commands::CalculateScore` - calculates game scores according to frames
- `Commands::CreateDelivery` - add delivery to the curren game, distributes deliveries
- `Repositories::GameRepository` - communicates with storage object
- `Presenters::GamePresenter` - decorates game status before sending in response.
3. Exchangeable storage to store game data is passed to repository as dependency.
4. Custom exception objects with configurable messages.
5. Self-explanatory code and test coverage with integration and unit tests.

