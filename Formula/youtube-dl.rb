# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.07.03.1/youtube-dl-2016.07.03.1.tar.gz"
  sha256 "be5918b87707637bddb2d01d408d9dd7ded00b03fca0623124803e11c113d163"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9b503f64f27a9efbb82e9a889233617d1ec030bf378e357778d2b89785a931f" => :el_capitan
    sha256 "8b324759b476e4bd4a9f23c58770c418cf7a6783c8c512917a8dd11b52b5418b" => :yosemite
    sha256 "e7ed11786e672bd89f3c883636e97ad312bf024cc7fd89ae4d8302e7dca0f7ea" => :mavericks
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
