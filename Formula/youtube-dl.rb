# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.07.26.2/youtube-dl-2016.07.26.2.tar.gz"
  sha256 "a5a4848a430adf51773dd2b2f4b2ea64e57a50aa0816d31aab95549219effacc"

  bottle do
    cellar :any_skip_relocation
    sha256 "80738ec80409da20b67f27c8214553d24844f87cc7b02c35ada9d9bbcf767d27" => :el_capitan
    sha256 "6a10d80dcf8e78f178730cc48d516960c93d3c80b555058a8d1283a85d47d67c" => :yosemite
    sha256 "c8a5bd14314bc1ae5ced6df96cc07ee17dc85a066d76720b8f93c89b5ac7c9ef" => :mavericks
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
