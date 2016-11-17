# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2016.11.18/youtube-dl-2016.11.18.tar.gz"
  sha256 "8e4bb3ef4f90ed03c822ff0bffce54d298cdf135d57bf4ff1605fc85157c0d3a"

  bottle do
    cellar :any_skip_relocation
    sha256 "a02f4c5cc106714b2c2d77692184f1d36c2f69b314b49f1871abb65bc82cfca0" => :sierra
    sha256 "a02f4c5cc106714b2c2d77692184f1d36c2f69b314b49f1871abb65bc82cfca0" => :el_capitan
    sha256 "a02f4c5cc106714b2c2d77692184f1d36c2f69b314b49f1871abb65bc82cfca0" => :yosemite
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
