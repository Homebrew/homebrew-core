# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2017.01.28/youtube-dl-2017.01.28.tar.gz"
  sha256 "3ca165456799a9a60c875caed37e70c8fe3279326f2715837fcdc4304c64be99"

  bottle do
    cellar :any_skip_relocation
    sha256 "cfe46d6ff05352d3a6a4fc8b0956bb4e3d558d594ddda6f5421288cb1a3c2bfd" => :sierra
    sha256 "00a8da40c46efa518360925ffa3acdfd4bea5a508c7d76d06f9ea1aba4902635" => :el_capitan
    sha256 "00a8da40c46efa518360925ffa3acdfd4bea5a508c7d76d06f9ea1aba4902635" => :yosemite
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
