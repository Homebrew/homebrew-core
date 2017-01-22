# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2017.01.22/youtube-dl-2017.01.22.tar.gz"
  sha256 "bc9a3a99e1db58a1f5e91c9dc62801bdb499c27237f86bb670614d507c8e5887"

  bottle do
    cellar :any_skip_relocation
    sha256 "c87eca3fa8e1db979d7c9ac05379fd75c364de0ca1048972bb6393028512a085" => :sierra
    sha256 "b0275c09b43f22b835f88a2e93f811aad239a821a69a69559a94e060fd6f91a1" => :el_capitan
    sha256 "b0275c09b43f22b835f88a2e93f811aad239a821a69a69559a94e060fd6f91a1" => :yosemite
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
