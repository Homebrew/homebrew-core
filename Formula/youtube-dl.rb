# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.07.30/youtube-dl-2016.07.30.tar.gz"
  sha256 "c3a1e9732e2c44eccd97297f460a011d9822d068ba484156bf25cf11d1053ae9"

  bottle do
    cellar :any_skip_relocation
    sha256 "9917acbb931af1b1b38b96fb8e5cd6a5f11047543a5ee52a53f3ff091d5b9544" => :el_capitan
    sha256 "17d7f3c95ed4cf0e189da8acc20e24618c036e1e16c43fe7908027e540918de8" => :yosemite
    sha256 "3255645dba6307b91de9f6cf3ce85a4a80f6dbab36b3a79ea472efe58d5e8209" => :mavericks
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
