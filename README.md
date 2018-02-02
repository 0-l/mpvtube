# mpvtube
Basically just a youtube scraper that runs on a page and pipes the video url to mpv.

## Requirements
- [Ruby](https://www.ruby-lang.org/en/) `~2.2.4`
- [mpv](https://github.com/mpv-player/mpv)
- [youtube-dl](https://rg3.github.io/youtube-dl/)

##### Gems
- [sinatra](https://github.com/sinatra/sinatra)
- [eat](https://github.com/seamusabshere/eat)

## Usage
On the root of the project, run: `ruby app.rb` and go to `tcp://localhost:4567` on your browser.

Press `s` on the page to bring up the search input.

## TODOs
- [ ] Add 'playing' state when opening video
- [ ] Add paginating (maximum videos to display)
- [ ] Pipe mpv info into page

### Preview

[Animated preview](https://i.imgur.com/ym2H7AK.mp4)
![mpvtube-preview](https://i.imgur.com/rem64By.jpg)

##### Terminal version:
![mpvtube-terminal](https://i.imgur.com/8e7Gqkt.png)
