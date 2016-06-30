# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.07.01/youtube-dl-2016.07.01.tar.gz"
  sha256 "ffb6f2b9369ed239e2c139167dc60c521747875a2f5c45917c3b88c8ed74dd36"

  bottle do
    cellar :any_skip_relocation
    sha256 "04acf7a8929e91d071c87b4bdd06a783f1fe7fe5b9c397986a13887089e5fa3e" => :el_capitan
    sha256 "10ab7b6d55a57208daf37f54241bba1a3fed5db48546276e1fae3c46c3b5c203" => :yosemite
    sha256 "409ca531cd8ea5f72a9fa88e0578717af51dd87803a620f7adb64ef311131e2f" => :mavericks
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
