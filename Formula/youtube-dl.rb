# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.08.13/youtube-dl-2016.08.13.tar.gz"
  sha256 "b68b00744f5578c3225d1231d4001a39c79b5912a68de2da1c39c648e36dfeba"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab2b1b7c3d2bc4537045f00cd62b40e554489376b2da1fb6a08b783ab27aa564" => :el_capitan
    sha256 "bbdf7f1a4930b8a0304327f5839a1851632871ff8af72cb1d5a997cd0c2ba020" => :yosemite
    sha256 "f11c5b7b51faf56457a53ac2e818727b8354d6795621e85bf50cec85a7226799" => :mavericks
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
