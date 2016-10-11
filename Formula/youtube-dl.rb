# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2016.10.07/youtube-dl-2016.10.07.tar.gz"
  sha256 "56be6107275cbdc867e89caf9d20f351d184fdc4fb06d915945fef708086dbce"

  bottle do
    cellar :any_skip_relocation
    sha256 "a432e25711674363b9d6f439e856d000dbf288df3acc7b0c9c316480160eaf03" => :sierra
    sha256 "a432e25711674363b9d6f439e856d000dbf288df3acc7b0c9c316480160eaf03" => :el_capitan
    sha256 "a432e25711674363b9d6f439e856d000dbf288df3acc7b0c9c316480160eaf03" => :yosemite
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
