# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.07.13/youtube-dl-2016.07.13.tar.gz"
  sha256 "16cda6c8151445b90d3c43412788ff0bb7176e7d7d2a4325642b0e8113249443"

  bottle do
    cellar :any_skip_relocation
    sha256 "85bf370f07ca85602a3d64554b90dea8bb667533bccce6c68f6d24c4155d69bc" => :el_capitan
    sha256 "273dd99e6cd641c667b947a43b87830fd0b65a854cad61e29c40cfa615c29176" => :yosemite
    sha256 "8d1b6ec9b4de00f42054ef652c3658effb76e46d696af75bf15be70de97ed614" => :mavericks
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
