# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.08.01/youtube-dl-2016.08.01.tar.gz"
  sha256 "b11f9abcfcad4ea7bf370bd80a7f8751a85e26e840337a9df60a6e9e73a6d7a1"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f76f160480908b8b3b0ca53448844f13265cb9a2d0796e91312ff0678936f58" => :el_capitan
    sha256 "4c47294b0c8e498d2b85f2aa9b9c634b6d10e2b44f03ee963ccbc712d3e5231c" => :yosemite
    sha256 "9f0d7af410e9360f9d41d02e33acfa6b2d7e52de8c369952b052f3623f60629a" => :mavericks
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
