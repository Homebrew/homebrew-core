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
    sha256 "366769875a424187897380278d450add8416d79a662d976793af79814c1e9b7a" => :el_capitan
    sha256 "90ce248446752519b28c5b14ae949eb0eba464f2cf22cd795643054d85c155c3" => :yosemite
    sha256 "61108fc3d5272627459cc68abfe3a20a87a428ad31fc6441a6d0c52be15d3c23" => :mavericks
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
