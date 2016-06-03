# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.06.03/youtube-dl-2016.06.03.tar.gz"
  sha256 "29d9eb4eeea9c781010ee6111a8d0dc6469b9974fbd76c6c6d1641f3e8d489e2"

  bottle do
    cellar :any_skip_relocation
    sha256 "1cec41f9597a411319cdd9c9bf68e6486a664117215c49cef987ac9fd8600c3b" => :el_capitan
    sha256 "7e3f20f7538f21e3c5ee208541d5f27661bbc1395c031c03080fbd5f309bba64" => :yosemite
    sha256 "b1b2b46890e7ac18cf6b6206a7712e7913829e2e39abfc99768b71f5fb3d2c58" => :mavericks
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
