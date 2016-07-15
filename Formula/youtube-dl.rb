# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.07.16/youtube-dl-2016.07.16.tar.gz"
  sha256 "cf6d481239c2d002596ce703dabc53c6271f924b4c255be5f54c2dc13014fd04"

  bottle do
    cellar :any_skip_relocation
    sha256 "0bdf4b3f700efae321e306b77f845308ef3a55a3e4ee93c49a5b76229f896b6d" => :el_capitan
    sha256 "4d87c41624618a48ff777701d312147e2876d87a1d1d3bf2dfa0d143448893a3" => :yosemite
    sha256 "157f4200749ee53adfebe621a8cdf073ad8778666194be1f901c9d94e4f648f5" => :mavericks
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
