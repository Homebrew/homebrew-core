# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.08.12/youtube-dl-2016.08.12.tar.gz"
  sha256 "fb5224b78cee45df9514d96441c4ec9d9934215e504c07fe8c9252285a33ea5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "22a2e03beaf66ea18a61a08ef3b62522a42b43793df965b3dd56f5456d302075" => :el_capitan
    sha256 "fa802183bba4c5d2b8c7bb74735bccb2857d3b2262acedc6805e9bd9dc7a129d" => :yosemite
    sha256 "2dbef81fd98be414b934ba4f7abc716b4ab88d50036f33377adb4d06f8ee5b1f" => :mavericks
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
