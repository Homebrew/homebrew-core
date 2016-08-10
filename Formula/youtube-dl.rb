# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.08.10/youtube-dl-2016.08.10.tar.gz"
  sha256 "6ca3d821e29240776f4d42c2d9442ea3fff1fcd2294e171acc86b45876e2aac5"

  bottle do
    cellar :any_skip_relocation
    sha256 "6352bd9c6594fe1317648aecb8d610a2fa629cca6fc80fb62d41df558720fb42" => :el_capitan
    sha256 "721498db564a759f7d49588ea478296165d453d865fa857fc994a29e7711f0b2" => :yosemite
    sha256 "549336aff54f0f391443db755d033c7dfbda3170fa0bd2e944e40a1fb49d306d" => :mavericks
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
