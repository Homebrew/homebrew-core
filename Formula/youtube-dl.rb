# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2016.12.31/youtube-dl-2016.12.31.tar.gz"
  sha256 "94d9f6cb99a1f5c27a8885f1bffe1f36c7e89feef961a83f78d8093284cf1ec9"
  head "https://github.com/rg3/youtube-dl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "668f265abf4c08ea952669bd30c1a9965a30f94b069bf1363524fd7cf3dd24cd" => :sierra
    sha256 "5734343442a8853b2cf571a2413e8e9bdf6649f6879e634fda1ce4d9ffaa0333" => :el_capitan
    sha256 "978c685e46677d40ca8ff8e50efda2af2b43adc007fdd055540cba9bc28e83f4" => :yosemite
  end

  depends_on "pandoc" => :build
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
