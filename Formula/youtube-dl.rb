# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.07.24/youtube-dl-2016.07.24.tar.gz"
  sha256 "a333984dcda7ac064d729083d8a4778ef8792f1e4224c42da8ed9e302f602ae1"

  bottle do
    cellar :any_skip_relocation
    sha256 "194351cd7fc3093820b90e76caac2e1c7d49cbf0554d6d43fabf8e44caa06433" => :el_capitan
    sha256 "b0e67c120d22afa44000732ff4608a5261fea7b111477c348b6032c553428175" => :yosemite
    sha256 "e0857711e5c9db837b8ef21081d90a6b9b1546ac4accd99bb204f893b467a9dd" => :mavericks
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
