# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.07.09.2/youtube-dl-2016.07.09.2.tar.gz"
  sha256 "a339e0942e438061d701ffcdf9dcb3001e4f6b91e3046147bf4a081eb44e4963"

  bottle do
    cellar :any_skip_relocation
    sha256 "721d9ac61a35b03133692254edc5fd67e907be6de64c98d8de6991a863604b23" => :el_capitan
    sha256 "c88b341435e81b2e0b21f6a82843f65e2709fc901039c2892cac17cef76cd945" => :yosemite
    sha256 "38a63ba36e213773692c1ef39cf29300857356322b450140379795655f30ebf6" => :mavericks
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
