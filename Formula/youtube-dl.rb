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
    sha256 "ecbce482ab610633b3424980915334c2c2e69305afe8e27831ddcfeac8d62d73" => :el_capitan
    sha256 "f720e352232dda3079c63b20ecb0d72de3c31dd6256a3d4f473c265204523400" => :yosemite
    sha256 "8c76d6b80ca801c33357081393b7dcc46ee1858486f1cbd831019b45ae1893da" => :mavericks
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
