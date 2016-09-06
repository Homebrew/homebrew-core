# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2016.09.04.1/youtube-dl-2016.09.04.1.tar.gz"
  sha256 "3a84cab74d89f3dbe28f24cc8a012a6f7845ffb1b9d7131cd1e58fefaef035dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "aafabbbd922594d006b37c057baf377f7ea5ef93352177f46a0c2d5185866534" => :sierra
    sha256 "aafabbbd922594d006b37c057baf377f7ea5ef93352177f46a0c2d5185866534" => :el_capitan
    sha256 "a100c05b0720f60c5d693dcb4aa6abbabc4fd2cd990b733d7a5d4add7ecae350" => :yosemite
    sha256 "a100c05b0720f60c5d693dcb4aa6abbabc4fd2cd990b733d7a5d4add7ecae350" => :mavericks
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
