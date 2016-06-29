# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.06.27/youtube-dl-2016.06.27.tar.gz"
  sha256 "6ccb3ab1b2e3d5c231b9fff3bffe7c60b3c4973a8269bbe6a5b6835527109bcf"

  bottle do
    cellar :any_skip_relocation
    sha256 "edea3d3ecf22189c21357f1109879fc63141c0562c02585028049f31cba6928b" => :el_capitan
    sha256 "6dedb39a0990a30a855b82c5d3585cdc90bd681f56cab8e5e3087a4a96a4c756" => :yosemite
    sha256 "ff461235d33deafcda724daa4f89dd1c9fd445e303bdd20335c28ecc74c2fe8f" => :mavericks
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
