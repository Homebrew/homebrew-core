# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.06.16/youtube-dl-2016.06.16.tar.gz"
  sha256 "ec4d186c355149a184101c0abe87227ccea61b99f46fcbb5ace0dff35519a3d0"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc07a8865e1f77de3039b7a3b375d525094307679998144d74b4fbb75df84f2a" => :el_capitan
    sha256 "41ccef5a1b79af5c38ddaee1fb78e54fdcd0cbea3c6ccae24bf91e42df680c67" => :yosemite
    sha256 "d25f31dc059394dd8bfc55402c37127fc58adec92678f2218eaa7a8c49079042" => :mavericks
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
