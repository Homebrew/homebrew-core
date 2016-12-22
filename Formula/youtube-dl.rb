# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2016.12.20/youtube-dl-2016.12.20.tar.gz"
  sha256 "f80d47d5e2a236ea6c9d8b4636199aea01a041607ce7b544babedb0fe1ce59a5"

  bottle do
    cellar :any_skip_relocation
    sha256 "8aeeca7ff66eb63b3c2cda2ce7a78f4f6a2aab713b5bf8c4034dde35f214ea37" => :sierra
    sha256 "9a98825497d92270839c20f6264f7c8fd6bcf59ad0741b8f5ce90d06d7fba826" => :el_capitan
    sha256 "9a98825497d92270839c20f6264f7c8fd6bcf59ad0741b8f5ce90d06d7fba826" => :yosemite
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
