# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2017.03.20/youtube-dl-2017.03.20.tar.gz"
  sha256 "6e4201d7b45da75e9ed04c0393e9b1ce86fad27375337d5e1700549a26597215"

  bottle do
    cellar :any_skip_relocation
    sha256 "dcede4ff2da08acf2ee876a9f72127188d1890be66140170f48d97f9418b6ac3" => :sierra
    sha256 "dcede4ff2da08acf2ee876a9f72127188d1890be66140170f48d97f9418b6ac3" => :el_capitan
    sha256 "dcede4ff2da08acf2ee876a9f72127188d1890be66140170f48d97f9418b6ac3" => :yosemite
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
