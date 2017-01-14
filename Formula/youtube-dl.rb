# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2017.01.14/youtube-dl-2017.01.14.tar.gz"
  sha256 "76c8bd77db6c820bfa72f1e2a873101ca736fd1d9954ccebf349fa7caef99cca"

  bottle do
    cellar :any_skip_relocation
    sha256 "acdaa6c4211815e1988dacec9e8e04360700cba899f8c213576deac9b6642930" => :sierra
    sha256 "a6194690e57285548c90663cbba1b4c6ae3c33c05637d92b294860f613813891" => :el_capitan
    sha256 "a6194690e57285548c90663cbba1b4c6ae3c33c05637d92b294860f613813891" => :yosemite
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
