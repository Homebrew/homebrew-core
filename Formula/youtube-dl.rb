# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2016.09.08/youtube-dl-2016.09.08.tar.gz"
  sha256 "c45af2fb1041c25ee9b2283f5c0bd32106943844425541d684e17310e216b8b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "16bd18b5a6345e16f3719957572df2ca976e0b620719fc0441d521fd6c7f4f6b" => :sierra
    sha256 "e4d7b97ab5f7777c182be14df587973bf0d7fba85552d011a32eadcbd90353da" => :el_capitan
    sha256 "16bd18b5a6345e16f3719957572df2ca976e0b620719fc0441d521fd6c7f4f6b" => :yosemite
    sha256 "16bd18b5a6345e16f3719957572df2ca976e0b620719fc0441d521fd6c7f4f6b" => :mavericks
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
