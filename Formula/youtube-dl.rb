# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.07.09.1/youtube-dl-2016.07.09.1.tar.gz"
  sha256 "244585080738b4ea6374559c55a38d11577d36cccead6cf90a57c15e55500b36"

  bottle do
    cellar :any_skip_relocation
    sha256 "22b1a4f67c9421b7ab738560314104488289f082c7a2b6e2b46c6ef9cfbfcb48" => :el_capitan
    sha256 "288ba29a39cfb6ab50f220d3fea43fd9baf8a629a58bfa21e68f3224caf21a71" => :yosemite
    sha256 "8ff2697d6e74b9a936794607d23e37cebbc96ba9197d7ff6164745008a8d372a" => :mavericks
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
