# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.05.01/youtube-dl-2016.05.01.tar.gz"
  sha256 "adc812e840f8f2461d6b7e72876c9219bfc8004e650a6ac7ddf216ccab5304f0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad97e5b1f2aadd9ca19eba9cdfba048e4c0da6c26d866bced783a83ebfd283ea" => :el_capitan
    sha256 "6c4bb8126e0dfd0bb89382af141a22e57d091de61fd0d3a0f22aba0624d85e7d" => :yosemite
    sha256 "9f4e5263b4777f782b3fe6253b0be40a095f38cfe0bc40162e3a3c5343cefa27" => :mavericks
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
