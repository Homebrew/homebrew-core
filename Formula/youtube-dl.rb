# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2017.01.10/youtube-dl-2017.01.10.tar.gz"
  sha256 "6493d1400c5735221d65688548ada4d45875f25562f7c49c73263d9ae4369932"

  bottle do
    cellar :any_skip_relocation
    sha256 "ccfb5b5d4e49961d3c7eba65c175efdafd7ddeb45f833194209b2846b693010a" => :sierra
    sha256 "cd6b245b3102710e0e6d017b5d1c161d5ab9a3962b775a3605bc31f8dc7a0c74" => :el_capitan
    sha256 "cd6b245b3102710e0e6d017b5d1c161d5ab9a3962b775a3605bc31f8dc7a0c74" => :yosemite
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
