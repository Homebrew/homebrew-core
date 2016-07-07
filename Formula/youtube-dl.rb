# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.07.07/youtube-dl-2016.07.07.tar.gz"
  sha256 "9e2008db1f00140233ee188674eef96ba11e6e7bb84a51a9140ceb18f1c6942f"

  bottle do
    cellar :any_skip_relocation
    sha256 "806dbce5ef5701882334f4b4b9915e7e613109d58d74ef1bc932b21e8ff9df26" => :el_capitan
    sha256 "344c0a02a9db59cde584901b509cd9db68ea39522b381f2fff113095b33c4c6a" => :yosemite
    sha256 "8b530181691be822e147e2ec4a665d2f02cb329df62afbced1f0de0c671badbd" => :mavericks
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
