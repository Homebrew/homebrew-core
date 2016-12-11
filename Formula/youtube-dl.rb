# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2016.12.12/youtube-dl-2016.12.12.tar.gz"
  sha256 "643efa7755ac4aa03a241f106d8923dfd5dbaf8d3c14e56b696048c4f2fab430"

  bottle do
    cellar :any_skip_relocation
    sha256 "a71a40430f7a3f9d22bdbf307b74d2b4d7e2089e74404af907acf5b47bfea794" => :sierra
    sha256 "5c8e60ee6ebab63aaf9e734422cd73aa40521e33c31c7c38de7450b130ec1781" => :el_capitan
    sha256 "a71a40430f7a3f9d22bdbf307b74d2b4d7e2089e74404af907acf5b47bfea794" => :yosemite
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
