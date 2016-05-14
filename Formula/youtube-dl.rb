# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.05.10/youtube-dl-2016.05.10.tar.gz"
  sha256 "ccb96dd53b7bf7305db0430f8b3a2044fa24f5200903c95349e070f938ad0c3f"

  bottle do
    cellar :any_skip_relocation
    sha256 "812d728f4d17e3435d9339474df88f7e831448504d4ee8cbbcf64d3817407571" => :el_capitan
    sha256 "b2727d43ae8c275f8864e2c7dc54e2b7f84d5948ff079f994bda6c56e3281af5" => :yosemite
    sha256 "613a2a8e7896e5d5a21e5bd09ea20a175c82ff37c126828be3abbaf7398e4af8" => :mavericks
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
