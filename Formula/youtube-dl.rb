# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2017.03.05/youtube-dl-2017.03.05.tar.gz"
  sha256 "da0f4dd74479767d6791643b556fd856d48a1fa99f8c01d3c2ca6e957db9283d"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb4a0d4f2581299169363b0e88cbbb9788e4a30c95c5ec398e1292c4e59078f3" => :sierra
    sha256 "bb4a0d4f2581299169363b0e88cbbb9788e4a30c95c5ec398e1292c4e59078f3" => :el_capitan
    sha256 "bb4a0d4f2581299169363b0e88cbbb9788e4a30c95c5ec398e1292c4e59078f3" => :yosemite
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
