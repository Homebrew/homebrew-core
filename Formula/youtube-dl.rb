# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.04.13/youtube-dl-2016.04.13.tar.gz"
  sha256 "f9307cbf2f2e9baf4724d9a35beecd9c7728422c0bff5e9efd0e8a026cc952cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee220bed27103ff7f4c1683c4603b4b599fa5ab346e1f919f4979350e9836d19" => :el_capitan
    sha256 "ace3da841b6d63c1dbe6d8510e4fe0b22655170f21863afcf2403050fdbc3726" => :yosemite
    sha256 "323162c05565290436a378c4d82ea1bc7cd454f97911278fcacb4f3911b6bcfd" => :mavericks
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
