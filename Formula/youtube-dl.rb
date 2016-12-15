# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2016.12.15/youtube-dl-2016.12.15.tar.gz"
  sha256 "85d937a6edb8c14f8eac1b17d2e5d45574c7ec3f2cb792781ac1d8fb6a6ca39e"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e688fb49532bf9857c094761f75fceacbd6aeaa2a2e76b07b83f811ca41827c" => :sierra
    sha256 "c13de67a99354d6137c01da7636cc85f83c02ca6823cc5ffb9401e83f429e330" => :el_capitan
    sha256 "c13de67a99354d6137c01da7636cc85f83c02ca6823cc5ffb9401e83f429e330" => :yosemite
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
