# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.07.24/youtube-dl-2016.07.24.tar.gz"
  sha256 "a333984dcda7ac064d729083d8a4778ef8792f1e4224c42da8ed9e302f602ae1"

  bottle do
    cellar :any_skip_relocation
    sha256 "f683dd6daa22ab224163bfc614fb0874c48c8bef27af69679c762fd492775f3e" => :el_capitan
    sha256 "700e46d4da33d7233ff187d4b5cc2b1606b9d6db0095c2fd5b1a05aba606c788" => :yosemite
    sha256 "3b33cbdfa020eaeb06b0f74c245a9d9e9b8d62d32119e5e80a9632106ec34187" => :mavericks
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
