#!/usr/bin/env ruby
# encoding: utf-8

%w{sinatra eat openssl}.each do |lib|
  require lib
rescue LoadError
  puts "Installing gem - #{lib}"
  system "gem install #{lib}"

  Gem.clear_paths
  retry
end

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

trap("SIGINT") { `taskkill -pid #{Process.pid} -f` } if RUBY_PLATFORM[/mingw/]

post '/' do
  @search = params[:query]

  if @search
    error   = false
    query   = "https://www.youtube.com/results?q=#{@search.downcase}&hl=en" rescue (error = true)
    max     = 20
    search  = eat(query)
    vinfo   = {}
    vinfo_a =
    [
      search.scan(/a href=\"\/watch\?v=(.*?)\"/).collect { |i| i.join },
      search.scan(/a href=\"\/watch\?v=.*?\> - Duration: (.*?)\.\</).collect { |i| i.join },
      search.scan(/a href=\"\/watch\?v=.*?dir="ltr"\>(.*?)\</).collect { |i| i.join },
      search.scan(/a href=\"\/user\/(.*?)\"/).collect { |i| i.join },
      search.scan(/a href=\"\/watch\?v=.*?\/li\>\<li\>(.*?)\s*views\</).collect { |i| i.join },
      search.scan(/a href=\"\/watch\?v=.*?li\>(.*?)\</).collect { |i| i.join },
      search.scan(/[src|data-thumb]+=\"(https\:\/\/i\.ytimg\.com\/vi\/.*?hqdefault.*\?)/).collect { |i| i.join }
    ] if !error

    vinfo_a[0].each_with_index { |video, index|
      vinfo[video] =
      {
        "time"     => vinfo_a[1][index],
        "title"    => vinfo_a[2][index],
        "user"     => vinfo_a[3][index],
        "views"    => vinfo_a[4][index],
        "created"  => vinfo_a[5][index],
        "thumb"    => vinfo_a[6][index]
      }
    }

    @vinfo = vinfo

    @max = max
  end

  erb :index
end

get '/mpv' do
  @link = params[:link]

  print "Playing #@link"
  system "mpv #@link"

  redirect :/
end

get '/download' do
  @link = params[:link]

  print "Downloading #@link"
  system "youtube-dl #@link"
end

get '/' do
  erb :index
end

