# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2016.08.28/youtube-dl-2016.08.28.tar.gz"
  sha256 "520d913129ef03fb62c3f1a430db257c962da61b534caccbdd3a0b01e7a96487"

  bottle do
    cellar :any_skip_relocation
    sha256 "caf509f90bc9c15618a646cbb04aac940372f1533b12567335158b535fdcf2a4" => :el_capitan
    sha256 "0bccf05a8dbaf9eec5b325e4ef5f804f6531c579ce3edcd791466c70b4da1540" => :yosemite
    sha256 "0bccf05a8dbaf9eec5b325e4ef5f804f6531c579ce3edcd791466c70b4da1540" => :mavericks
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
