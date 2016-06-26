# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.06.26/youtube-dl-2016.06.26.tar.gz"
  sha256 "31cf6731b5fd119e34556b1afa8bc7b49d76f7c085c5d0a71d40f2b745d6108a"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9b39e3826177dd926d1a75adc951bc6a044f10957446d98c79f3e44c1fd085a" => :el_capitan
    sha256 "6442cb7d55e3fe7dd8fa33c2a01bcb81b8f8b26bfb09bc84668b1d485eaabf19" => :yosemite
    sha256 "9249235cbce7412632c0b490596ae4cfb3f92b18a41ca5da03e2e599e9fb698c" => :mavericks
  end

  head do
    url "https://github.com/rg3/youtube-dl.git"
    depends_on "pandoc" => :build
  end

  depends_on "rtmpdump" => :optional

  def install
    system "make", "PREFIX=#{prefix}"
    bin.install "youtube-dl"
    man1.install "youtube-dl.1"
    bash_completion.install "youtube-dl.bash-completion"
    zsh_completion.install "youtube-dl.zsh" => "_youtube-dl"
    fish_completion.install "youtube-dl.fish"
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=he2a4xK8ctk"
    system "#{bin}/youtube-dl", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=AEhULv4ruL4&list=PLZdCLR02grLrl5ie970A24kvti21hGiOf"
  end
end
