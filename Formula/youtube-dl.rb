# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.08.19/youtube-dl-2016.08.19.tar.gz"
  sha256 "9094084dceeeea47da3f8a3071c608b81e28f7c1e8c9b3e92da6b55aeeae961f"

  bottle do
    cellar :any_skip_relocation
    sha256 "269d7e43fa2a1f78f2f9c75b2cb49b56d4d75e8c83106220b2187c6f0b058403" => :el_capitan
    sha256 "3edef3ba99d241f176e031d2335f086b6daefbb4497b50a77c28424b5065ef15" => :yosemite
    sha256 "3edef3ba99d241f176e031d2335f086b6daefbb4497b50a77c28424b5065ef15" => :mavericks
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
