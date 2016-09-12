# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2016.09.11.1/youtube-dl-2016.09.11.1.tar.gz"
  sha256 "6cdeb0876295bef0325b8433c47c1ed13ebab3b108ef5ee27171e06b6958cb35"

  bottle do
    cellar :any_skip_relocation
    sha256 "833d2668443e82a1376ecfc6109f4038e31286649d5c32857fa7fb210282e3a5" => :sierra
    sha256 "3cbca83537a925d91c93310973b77d79f042c0af07eaebe10d56db73b70204fe" => :el_capitan
    sha256 "833d2668443e82a1376ecfc6109f4038e31286649d5c32857fa7fb210282e3a5" => :yosemite
    sha256 "833d2668443e82a1376ecfc6109f4038e31286649d5c32857fa7fb210282e3a5" => :mavericks
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
