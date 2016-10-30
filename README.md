**This repo is a work in progress. I am updating this incrementally.** 

# TweetTweet
Homework 3! Codepath Twitter Demo Client

**TweetTweet App** is a prototype of the Twitter app using the [Twitter API](https://dev.twitter.com/overview/api).

Time spent: **21** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign in using OAuth login flow
- [x] User can view last 20 tweets from their home timeline
- [x] The current signed in user will be persisted across restarts
- [x] User can view tweet with the user profile picture, username, tweet text, and timestamp
- [x] Design the custom cell with the proper Auto Layout settings. 
- [x] User can pull to refresh
- [ ] User can compose a new tweet by tapping on a compose button.
- [ ] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.

The following **optional** features are implemented:

- [ ] When composing, you should have a countdown in the upper right for the tweet limit.
- [ ] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [ ] Retweeting and favoriting should increment the retweet and favorite count.
- [ ] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [ ] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [ ] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

![Video Walkthrough](tweet.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

This well was smoother for me in terms of development. It took me quite some time to get through the OAuth videos. I had a few misunderstandings about how that fit together and how to probably set up my accessToken.

I also initially had trouble with completions. My autocomplete has been pretty finicky in xcode so understanding the syntax and trying to make it work, soaked up more time than it should. I also had an issue here I wrote something like this
```
tweet.unretweet(completion: { (newTweet, error) in
  if error != nil {
    self.retweetActionButton.setBackgroundImage(UIImage(named: "retweetActionOn"), for: UIControlState.normal)
  }
})
```
But I realized that I wanted to alter the `tweet` object with data I received from the completion. It seemed to update `newTweet` but the original `tweet` I used to call `tweet.unretweet` didn't update. Or at least it's internal value didn't change when I was observed at the end of the completion.

I did have some ininital difficulty with how to understand hiding and showing the Name Retweeted at the top if a retweet in combination with AutoLayout. I ended up having to redo my layout with StackView multiple times, first solely with Autolayout, then Stack View and Autolayout, then finally with nested views inside of a Stack View.


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
    
    

