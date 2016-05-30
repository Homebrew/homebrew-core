# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.05.30.2/youtube-dl-2016.05.30.2.tar.gz"
  sha256 "1ffb367f65f5f0ebdaaee92db509e49e88cbd27fc83d34e80ec3e9b5a3c797ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "09d74f1ad73a6806d855c0185a98d8bfa19f72d0b926721d0534da2240cce6d5" => :el_capitan
    sha256 "3c1fd162d146e1b98a3a4c78c581ec16008fbfc31ae51155e1e3d508a7924fa7" => :yosemite
    sha256 "425900ea98df3ed004f40ea318c0b2154f8c23a18344723de43ab0ea876ba4c6" => :mavericks
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
