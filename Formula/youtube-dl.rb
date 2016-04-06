# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.04.06/youtube-dl-2016.04.06.tar.gz"
  sha256 "115a7443162198f12d97c2c1d83e69d462f78410a26d6dd5ae3c74603397b9cd"

  bottle do
    cellar :any_skip_relocation
    sha256 "8df3e93ab5b6bcc89bd2cb85e42e04c677cb9ca1be41c9b9051dc7a2e7b570e1" => :el_capitan
    sha256 "f43ce39ecaedf716e275ef34b19be964e29587ff57a4d2f47269dd55a30fef59" => :yosemite
    sha256 "22b584d835027a195cf7933d3553076571a1b49ab220c6613c4b819e526103d0" => :mavericks
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
