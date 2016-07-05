# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.07.05/youtube-dl-2016.07.05.tar.gz"
  sha256 "b6477f73b0b2ce18c88685cdb1194474312a951be3ab2d226c68b8c9ae651a65"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1cf1adde892dda6adf1e9f6824351c6740b5c4deaa977ce80c56a89f0d8d3db" => :el_capitan
    sha256 "06c3b3a9cbe8954e922c7f93b3a7c4231a98b25614065ccff3ad36fe2b8c647a" => :yosemite
    sha256 "4f3e1cabeb5f2a6581a3e2376124c9ad14086e3c66a5e0eb75be8a07d709e4c7" => :mavericks
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
