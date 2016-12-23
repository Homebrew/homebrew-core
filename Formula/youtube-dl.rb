# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2016.12.22/youtube-dl-2016.12.22.tar.gz"
  sha256 "f5bc5eb1af17391b7a1da795f4181c3702fb2c1da2668b25f1260dbdba882524"

  bottle do
    cellar :any_skip_relocation
    sha256 "2601c8704cac7e41ff2b571a2407a5c8d1cd7b2bce142ed19e5858717751d471" => :sierra
    sha256 "f35411edcc00d23b4a488b49af6fe688d5cc2286a7951ecf9e6bc96af87ce741" => :el_capitan
    sha256 "f35411edcc00d23b4a488b49af6fe688d5cc2286a7951ecf9e6bc96af87ce741" => :yosemite
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
