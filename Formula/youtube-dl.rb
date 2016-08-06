# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.08.06/youtube-dl-2016.08.06.tar.gz"
  sha256 "3010f0482881c49c65811ab62c1588b7ebae2cbca1be70294f8b657b4a69954f"

  bottle do
    cellar :any_skip_relocation
    sha256 "7cd02b59f628da20c1f85b5925a55a155ee8731aa663a147b39a02278afcbb09" => :el_capitan
    sha256 "a692b1bf8cbfb2c6d98a3984d48ff1883983bd28eb9fb54270a4e118e56525ca" => :yosemite
    sha256 "272feebfd97d235fcefb275f269309928b34ac5422d2bb910eeb88475228ea8a" => :mavericks
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
