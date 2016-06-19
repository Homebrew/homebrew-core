# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.06.19.1/youtube-dl-2016.06.19.1.tar.gz"
  sha256 "223c496be84dd57ba9f7d6a132a2732b67c79c7e26e64ecae1439472c10d0d45"

  bottle do
    cellar :any_skip_relocation
    sha256 "a086298e1cbd5dcd4331ae758b3395aaa8268306605502f64f00debde040ded8" => :el_capitan
    sha256 "442bb272db1dd58cd5e6adabf2a73b93a38a25c55704e8ddf2aae25256d8ae65" => :yosemite
    sha256 "5a8bb32f4f405a5a265da16772f9b0775620ad6e561a3fbc3ef81ad0c34256c4" => :mavericks
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
