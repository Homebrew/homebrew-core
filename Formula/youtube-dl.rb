# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2017.03.02/youtube-dl-2017.03.02.tar.gz"
  sha256 "2f010132da4cc3e67582f89eff9bc4bb4c0e7b60c0ddba101370d97eafc50639"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf8ea48fc099d32b421c78896c03cb3ac4510897f42c3e26bf964865b5205d3a" => :sierra
    sha256 "bf8ea48fc099d32b421c78896c03cb3ac4510897f42c3e26bf964865b5205d3a" => :el_capitan
    sha256 "bf8ea48fc099d32b421c78896c03cb3ac4510897f42c3e26bf964865b5205d3a" => :yosemite
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
