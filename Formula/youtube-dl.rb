# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.07.22/youtube-dl-2016.07.22.tar.gz"
  sha256 "69aad90eb92d0c2814ebdd3eefc863ad74a02a490e42cbbadf4befbbd8ed8c0b"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce7ad8b7a1c06df620f0c951ca56b95208f53e002df6f59dae1bc69a060bca6c" => :el_capitan
    sha256 "41efdd471fc2bdd7d533ec0ee941b4798d855e544806c8a0523d2b0bacc3833e" => :yosemite
    sha256 "cf0f6e2b0886506e73dd6d351c84f6470e4641746f9d3c11c2476372b4456961" => :mavericks
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
