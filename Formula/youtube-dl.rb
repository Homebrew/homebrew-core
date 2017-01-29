# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2017.01.29/youtube-dl-2017.01.29.tar.gz"
  sha256 "3475380e277f3517322c355815a1d7e023a023a565b3c724247c9a9509eb3a6e"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b5ff2692471fcb1392b7fb7424248ae54c196964a852a64ce749713e6717e64" => :sierra
    sha256 "8124fd094447e426ef8de3b72cb9c927f6586b1233146fbe0660421d4921ae92" => :el_capitan
    sha256 "8124fd094447e426ef8de3b72cb9c927f6586b1233146fbe0660421d4921ae92" => :yosemite
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
