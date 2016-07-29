# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.07.28/youtube-dl-2016.07.28.tar.gz"
  sha256 "cc8e72b6ca89a2df22b6626018360a45ebd59accd5cb9d82d185d4ea4d0e7fea"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0335b7833d2fb7e17498cb58a8a17f6dcdfd6d4421eb1438e663cd824e187ab" => :el_capitan
    sha256 "6041f6e090cb54d2929b3dcfe033d8d3793c612e2a52b8a64ae3947f4cfb4acd" => :yosemite
    sha256 "5de62b4b388771161b8fa1512703f75f00d2389abcbfe0e323ad24279f1ff756" => :mavericks
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
