# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.07.07/youtube-dl-2016.07.07.tar.gz"
  sha256 "9e2008db1f00140233ee188674eef96ba11e6e7bb84a51a9140ceb18f1c6942f"

  bottle do
    cellar :any_skip_relocation
    sha256 "711432db0d4039a3a6e447eb678d924b810bdb40a678e6f13926fe29e847f305" => :el_capitan
    sha256 "de2d6557b73d33c3a4e99086edfe9ba92071de835d0fe26758cbf61a3b667b22" => :yosemite
    sha256 "eac456cb677deff46ae3835b5428ef76ecf07e45dbd1868d81824fe21baae81a" => :mavericks
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
