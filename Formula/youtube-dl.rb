# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2016.12.01/youtube-dl-2016.12.01.tar.gz"
  sha256 "ddff281a251c7a40bf8c28afa1df63e9a64ff61b6b8097535fbbe587e8ccaef7"

  bottle do
    cellar :any_skip_relocation
    sha256 "9aab657b365b99f57b0068591edc19303ac6312cfa70118803ed5c66212782cd" => :sierra
    sha256 "9aab657b365b99f57b0068591edc19303ac6312cfa70118803ed5c66212782cd" => :el_capitan
    sha256 "9aab657b365b99f57b0068591edc19303ac6312cfa70118803ed5c66212782cd" => :yosemite
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
