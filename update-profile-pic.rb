require 'open-uri'

File.open("./assets/images/profile.jpg", "wb") do |file|
    file.write open('https://github.com/espositoandrea.png').read
end