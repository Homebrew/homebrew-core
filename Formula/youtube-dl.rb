# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2016.09.04.1/youtube-dl-2016.09.04.1.tar.gz"
  sha256 "3a84cab74d89f3dbe28f24cc8a012a6f7845ffb1b9d7131cd1e58fefaef035dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ce2e7e646664abfd4c69c030a3c88cfe588b16211e75deab9f8e1fa5804b4b8" => :el_capitan
    sha256 "3e3171e911a07933d3a530ea38d05515178fd7d1d49c8ba5f60169e1cefcc9f8" => :yosemite
    sha256 "3e3171e911a07933d3a530ea38d05515178fd7d1d49c8ba5f60169e1cefcc9f8" => :mavericks
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
