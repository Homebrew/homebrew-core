# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2016.10.25/youtube-dl-2016.10.25.tar.gz"
  sha256 "920048c6ff2f7f2c4b55c1ba4810e85f76efd814118e59b3568bdc2c38024697"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d472f79404de896de88de22274b7cac3f7c47f4cace2bc456e2564b93b46192" => :sierra
    sha256 "5d472f79404de896de88de22274b7cac3f7c47f4cace2bc456e2564b93b46192" => :el_capitan
    sha256 "5d472f79404de896de88de22274b7cac3f7c47f4cace2bc456e2564b93b46192" => :yosemite
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
