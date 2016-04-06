# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.04.01/youtube-dl-2016.04.01.tar.gz"
  sha256 "474a9d901252c05ec9d8131016dab4a2fb40d9c323e7ebdd5c5e30c9eee3e824"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a956ec20131c4718653d80a6e692cc07385dd127a4563d3320cc0ccc82d9e8a" => :el_capitan
    sha256 "5adae5a452316ad0cfb0cef5cb84129bc6094c9994bdd98040d691e6c5a9edda" => :yosemite
    sha256 "385ea82f44a1ec293801f537832aaff208ddfc7ec3920a6f9a9e7d29273e13bf" => :mavericks
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
