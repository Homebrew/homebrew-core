# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2016.08.31/youtube-dl-2016.08.31.tar.gz"
  sha256 "ca4b7bf3d7f9c5289ea2f53af3a68f201447ce4298337ee60826ee230e00313f"

  bottle do
    cellar :any_skip_relocation
    sha256 "fcd003c41367dcdfdc6f6f14ced72f17038a454e1a372bc96ef8af5607caac1e" => :el_capitan
    sha256 "b925c6cbd3d868fe6d623fe73daffc57cea634b879f7d2c809a2d075d1d3e79e" => :yosemite
    sha256 "b925c6cbd3d868fe6d623fe73daffc57cea634b879f7d2c809a2d075d1d3e79e" => :mavericks
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
