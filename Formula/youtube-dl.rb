# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2017.01.18/youtube-dl-2017.01.18.tar.gz"
  sha256 "7c16f3ce7cf8a673a4c531e4a1fc10801467a61732cb65430e40b3ab8b2f2d2e"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1730988317caa6cbaedb1b054e364d70c6dae017598877b7952880ca5b8f703" => :sierra
    sha256 "01ae20d827fa78b9e89d49e1f666af594182a483b688b3c8550a514ca132a402" => :el_capitan
    sha256 "01ae20d827fa78b9e89d49e1f666af594182a483b688b3c8550a514ca132a402" => :yosemite
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
