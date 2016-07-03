# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.07.03/youtube-dl-2016.07.03.tar.gz"
  sha256 "8877ded6c493fc9be70dc42dfb5b250baa659c12529b3b0c8406f1a96420a778"

  bottle do
    cellar :any_skip_relocation
    sha256 "25e7d7cd9587b466b3fa165d2a2628b7b9c731408f1233fc5eec91c638166bb3" => :el_capitan
    sha256 "270e4ab1752ba9135e6fca08060db3405b06d4118431001571dae1eab0b4c23c" => :yosemite
    sha256 "04b52813eb086eab32c49d5ec5256286bbdd20d885cf7be271ffa7ec3a5382fc" => :mavericks
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
