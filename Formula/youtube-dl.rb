# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2016.09.24/youtube-dl-2016.09.24.tar.gz"
  sha256 "d45a17fb6be7d2e6c3df56f54d1a944fac8b68a577b673d8b15cef8e47bb3a57"

  bottle do
    cellar :any_skip_relocation
    sha256 "6eed2f674071c5818ae657728833e533050baff94d38ade5b208cb2fe50988fe" => :sierra
    sha256 "6eed2f674071c5818ae657728833e533050baff94d38ade5b208cb2fe50988fe" => :el_capitan
    sha256 "6eed2f674071c5818ae657728833e533050baff94d38ade5b208cb2fe50988fe" => :yosemite
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
