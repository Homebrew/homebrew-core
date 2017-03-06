# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2017.03.07/youtube-dl-2017.03.07.tar.gz"
  sha256 "db4a9f91b23375da53b29859e0c9475c9e1ba24d2a51a26b0cedab376afa4ca5"

  bottle do
    cellar :any_skip_relocation
    sha256 "e5194c1d7c9e8b3c642eae4e8be40df393bf4676ee40c9a19b91e5ebcf49e99d" => :sierra
    sha256 "e5194c1d7c9e8b3c642eae4e8be40df393bf4676ee40c9a19b91e5ebcf49e99d" => :el_capitan
    sha256 "e5194c1d7c9e8b3c642eae4e8be40df393bf4676ee40c9a19b91e5ebcf49e99d" => :yosemite
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
