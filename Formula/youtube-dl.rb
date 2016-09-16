# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2016.09.15/youtube-dl-2016.09.15.tar.gz"
  sha256 "fa0c155d7a887d3f9fd0a3d031635defa566f7e82f62069d7b793c7dbc10f2c2"

  bottle do
    cellar :any_skip_relocation
    sha256 "514d6981f9e290c3162751216ace9c3d8c2979802c5e0a9a4d9b6721e9bf998b" => :sierra
    sha256 "bba846f7a0d8cd3e1a319a45e72bb60ed47d55b097a9069be2e0d6ebe4431fca" => :el_capitan
    sha256 "514d6981f9e290c3162751216ace9c3d8c2979802c5e0a9a4d9b6721e9bf998b" => :yosemite
    sha256 "514d6981f9e290c3162751216ace9c3d8c2979802c5e0a9a4d9b6721e9bf998b" => :mavericks
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
