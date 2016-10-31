# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2016.10.31/youtube-dl-2016.10.31.tar.gz"
  sha256 "b8a0889bf4fed2f54d8ebbc6ea7860feae05b122d1b192417af68159b83f0bb4"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd7818e4e641b4f99b794ffd926d4af475510627c98ea0d92e4610ea7bc7a81f" => :sierra
    sha256 "fd7818e4e641b4f99b794ffd926d4af475510627c98ea0d92e4610ea7bc7a81f" => :el_capitan
    sha256 "fd7818e4e641b4f99b794ffd926d4af475510627c98ea0d92e4610ea7bc7a81f" => :yosemite
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
