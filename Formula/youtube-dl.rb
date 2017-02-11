# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2017.02.11/youtube-dl-2017.02.11.tar.gz"
  sha256 "5b1353592f5a4dfb6f476c48b7f04b64799803672e83b1cb59e643715182b01a"

  bottle do
    cellar :any_skip_relocation
    sha256 "038c86769f5ea2a2d61f3ba13a444252269ddfb52d07f55fc84f11e566daeef5" => :sierra
    sha256 "038c86769f5ea2a2d61f3ba13a444252269ddfb52d07f55fc84f11e566daeef5" => :el_capitan
    sha256 "038c86769f5ea2a2d61f3ba13a444252269ddfb52d07f55fc84f11e566daeef5" => :yosemite
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
