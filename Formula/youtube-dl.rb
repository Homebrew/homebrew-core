# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2017.01.02/youtube-dl-2017.01.02.tar.gz"
  sha256 "140de01ea879cdc50bc34240802d5c10231baf448d7a664e6efeb9d5efb74d5b"
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
