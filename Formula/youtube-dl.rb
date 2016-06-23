# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.06.23.1/youtube-dl-2016.06.23.1.tar.gz"
  sha256 "fd4e2304eb71c934502929446596b898ca7197b26dabb3540795bcfcc16a2e13"

  bottle do
    cellar :any_skip_relocation
    sha256 "06342a9351d2d9e2d7d4a0800ae03747c88d722358ae920b26ff7ce022145187" => :el_capitan
    sha256 "bfd1c0345bb4105d9e7440ed0b87626ad32b7c2b71137cc5b6e8abdd29fc8fd0" => :yosemite
    sha256 "57cdf5ad5cf3078f99547dec4871ffada6ffd2c1e7f72d85e15ce08d447f7116" => :mavericks
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
