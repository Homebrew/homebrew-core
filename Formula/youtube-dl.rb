# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.05.21.2/youtube-dl-2016.05.21.2.tar.gz"
  sha256 "66f94fc97012c4c7a6338dc4df6ec62af66dcfc144c5e8c8cd8b5519756f1a98"

  bottle do
    cellar :any_skip_relocation
    sha256 "667d2d351b35de6979634b93927c52747c216a0347ab7f233473c1432ca143bf" => :el_capitan
    sha256 "6f147ab26fa26cfd68f8b930f429967186b9ba530c6856471aa2e5df32990309" => :yosemite
    sha256 "706acbdbd4339433b4695006c17e9cee7dbe566719c0d964fa987c7922089d93" => :mavericks
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
