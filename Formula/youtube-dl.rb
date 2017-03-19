# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2017.03.20/youtube-dl-2017.03.20.tar.gz"
  sha256 "6e4201d7b45da75e9ed04c0393e9b1ce86fad27375337d5e1700549a26597215"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a66b1a2f891146990a738a42929f94ae9319f10eba67df02b6c452e4a00b59c" => :sierra
    sha256 "9a66b1a2f891146990a738a42929f94ae9319f10eba67df02b6c452e4a00b59c" => :el_capitan
    sha256 "9a66b1a2f891146990a738a42929f94ae9319f10eba67df02b6c452e4a00b59c" => :yosemite
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
