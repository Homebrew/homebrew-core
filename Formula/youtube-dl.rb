# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.06.19.1/youtube-dl-2016.06.19.1.tar.gz"
  sha256 "223c496be84dd57ba9f7d6a132a2732b67c79c7e26e64ecae1439472c10d0d45"

  bottle do
    cellar :any_skip_relocation
    sha256 "861b29e2bfa549aec8a67a107b570c7b2d10c20ea42a0e8da83d478f23a30fe9" => :el_capitan
    sha256 "18b70d8a4e1779ebb8006a7cb9e0051e1910cb66ef126555335a1609249c90d8" => :yosemite
    sha256 "c81b77a7cec8385475bac6398419b28b03e95251aefecaa0729e999840ee36c2" => :mavericks
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
