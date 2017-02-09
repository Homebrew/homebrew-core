# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2017.02.10/youtube-dl-2017.02.10.tar.gz"
  sha256 "5127ab3d10dba2f1ee15d3f541deb44d698be49abb2cc9ba0b18462a88f84da9"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f07a62faf8cfc444a8ecf1c1fdd8ff6713d45cc7a0312ff2ad34f56982b4486" => :sierra
    sha256 "a576ac50af228239a0aba6612b99e57c1806489b21f9a1771f5c8531cd60ea30" => :el_capitan
    sha256 "5f07a62faf8cfc444a8ecf1c1fdd8ff6713d45cc7a0312ff2ad34f56982b4486" => :yosemite
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
