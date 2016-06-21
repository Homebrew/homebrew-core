# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.06.20/youtube-dl-2016.06.20.tar.gz"
  sha256 "2b377bf98fb1304f6f33e8365ef3e87e5c4f45e18b10186efd9604c24ac51281"

  bottle do
    cellar :any_skip_relocation
    sha256 "f26f3e1bc501c68f5522b02470a0b99b2f759cbcc61dbb4c1bade4346f75353d" => :el_capitan
    sha256 "cfdb28ad6be7932ee6678a766ca67e9d68a9231368823f97e038a76f815afc22" => :yosemite
    sha256 "28e0f72c95899e209c7a12ea6017122b369a31cba2d87903e08168712a68fbdb" => :mavericks
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
