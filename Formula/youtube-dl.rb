# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2017.02.04.1/youtube-dl-2017.02.04.1.tar.gz"
  sha256 "d212c5fd1c127c7fcb107a6fa894eeee3d7ea9e91d7feb70d851b6d72b510cab"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ab0a74a7bbf9ec609727ca2b705a1fb691dc1428019559b0e9aeddf5b621a83" => :sierra
    sha256 "434b34bfadc60f7dd91f04abab30650d721ee8cca5c620d1511484be060bcfc8" => :el_capitan
    sha256 "5ab0a74a7bbf9ec609727ca2b705a1fb691dc1428019559b0e9aeddf5b621a83" => :yosemite
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
