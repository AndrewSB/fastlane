# fastlane
Fastlane actions that I share across multiple apps

## Installation
Add `import_from_git(url: 'https://github.com/AndrewSB/fastlane/blob/master/Fastfile')` to your Fastfile

## Contents 
4 private lanes

#### itc
Deploys to itunes connect. It expects:

- `destination` The string `TestFlight` or `App Store`
- `project` The name of the xcodeproj you'd like to build from
- `scheme` The name of the scheme in the :project you're tryna build

#### build
A wrapper around `gym`. It expects:

- `project` The name of the xcodeproj you'd like to build from
- `scheme` The name of the scheme in the :project you're tryna build

#### post_to_slack
Posts to slack for you (you need to setup `slack` by giving it your API Token before calling this). It expects:

- `project` The name of the xcodeproj to get metadata from
- `scheme` The name of the scheme in the :project to get metadata from
- `destination` The name of the destination you're deploying to
- `channel` The slack channel to post in

#### push_notif
Sends an apple push notification to your mac, so you can be notified when 💩 is done. It expects:

- `title` The title of the push notification 
- `message` The message of the push notification, 
- `app_icon` (optional) the app image of the push notification, defaults to the fastlane logo
- `content_image` (optional) the image on the right side of the push notification, defaults to no image
