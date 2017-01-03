# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2017.01.02/youtube-dl-2017.01.02.tar.gz"
  sha256 "140de01ea879cdc50bc34240802d5c10231baf448d7a664e6efeb9d5efb74d5b"

  bottle do
    cellar :any_skip_relocation
    sha256 "34decc7d556cee30694da5cdb684a56dc5bc3ec3a443f82449a39d7167ca00f1" => :sierra
    sha256 "4dd2161222912ae05b61840e1095e8ec01f1866db5e7fde73a228661636a35c8" => :el_capitan
    sha256 "4dd2161222912ae05b61840e1095e8ec01f1866db5e7fde73a228661636a35c8" => :yosemite
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
