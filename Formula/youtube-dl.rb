# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.06.16/youtube-dl-2016.06.16.tar.gz"
  sha256 "ec4d186c355149a184101c0abe87227ccea61b99f46fcbb5ace0dff35519a3d0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ce5e630c966ce23de7a4cee13f35d6ce8d31a1c05814fb3e3f4ead6d90585d1" => :el_capitan
    sha256 "b2438ac73e46b138136bcc63605c4c907b530eb6445d4fd8bfad02f70d2855d1" => :yosemite
    sha256 "d7d40f8ef8377daaad884228a9b765d090fc3900735df884bca91e8118f9526a" => :mavericks
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
