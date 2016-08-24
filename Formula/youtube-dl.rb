# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2016.08.24.1/youtube-dl-2016.08.24.1.tar.gz"
  sha256 "d8ca8fb4dd2b3f90f4db5be44046ce18392dcadee40d3b8e7164cf4552ec99c5"

  bottle do
    cellar :any_skip_relocation
    sha256 "d199eeb92b46e62b64554af19fd89f9b4460e3cba11dceb62b80d3d62ac01163" => :el_capitan
    sha256 "94bc7d7f011a6d4d236e5db0f98971ba1ddebaf96ab87448701bcf441c22c019" => :yosemite
    sha256 "94bc7d7f011a6d4d236e5db0f98971ba1ddebaf96ab87448701bcf441c22c019" => :mavericks
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
