# TweetTweet
Homework 3! Codepath Twitter Demo Client

**TweetTweet App** is a prototype of the Twitter app using the [Twitter API](https://dev.twitter.com/overview/api).

Time spent: **30** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign in using OAuth login flow
- [x] User can view last 20 tweets from their home timeline
- [x] The current signed in user will be persisted across restarts
- [x] User can view tweet with the user profile picture, username, tweet text, and timestamp
- [x] Design the custom cell with the proper Auto Layout settings. 
- [x] User can pull to refresh
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.

The following **optional** features are implemented:

- [x] Added images so that photo media shows up when included in a tweet. Also removes the original url link from the text link.
- [x] Refactored tweet text to use NSMutableAttributedString and added styling for any user mentions or hashtags.
- [x] Replace links in tweet text with their displayable text and added styling
- [x] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.
- [x] User can pull to refresh only grabs the latest tweets the user has seen (not sure if this was originally required)
- [x] Retweeting and favoriting should increment the retweet and favorite count.
- [x] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [x] Also added styling so color changes as user retweet/unretweet and favorite/unfavorite.
- [x] Retweet and favorite count are formatted based on the count (i.e. 15k on the timeline view vs 15,821 on the detailed expansion, etc).
- [x] When composing, you should have a countdown in the upper right for the tweet limit. (I did lower left since that's in the current mobile app)
- [x] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [x] Made my own icons (compose icon and cross exit) that used global tint to get the twitter blue color. 



## Video Walkthrough 

Here's a walkthrough of implemented user stories:

![Video Walkthrough](tweet3.gif)

![Video Walkthrough](tweet.gif)

I kept getting rate limited so I'm just gna show one of the walkthroughs. tweet4.gif is the most recent version but it doesn't show all the functionality due to rate limiting. :/

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

This went way smoother for me in terms of development. It took me quite some time to get through the OAuth videos. I initiually had a few misunderstandings about how that fit together and how to probably set up my accessToken but I feel like I really learned iOS this week. Before, I kinda understood what was going on but this week, I felt more in control of what I was working on and I constantly refactored.  

I also initially had trouble with completions. My autocomplete has been pretty finicky in xcode so understanding the syntax and trying to make it work, soaked up more time than it should.

I did have some ininital difficulty with how to understand hiding and showing the Name Retweeted at the top if a retweet in combination with AutoLayout. I ended up having to redo my layout with StackView multiple times, first solely with Autolayout, then Stack View and Autolayout, then finally with nested views inside of a Stack View.

I spent more time than anticipated trying to replace the original url with its readable format and then coloring it in. I ended up reordering some of the steps but I spent more time then I originally expected given that user_mentions and hashtags were a similar concept I finished before implementing this.

## Questions

What's the best way to refactor common code in ios?
How do I make helper methods that an object's init class can use?
How do I create like a global helper class that has methods I'd like to use across the project? 

## License

    Copyright [2016] [Shola Oyedele]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
