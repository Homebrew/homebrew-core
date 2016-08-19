# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.08.19/youtube-dl-2016.08.19.tar.gz"
  sha256 "9094084dceeeea47da3f8a3071c608b81e28f7c1e8c9b3e92da6b55aeeae961f"

  bottle do
    cellar :any_skip_relocation
    sha256 "8592e838f656498c12acb5411e5a45b9e0bd4647c5658a54f1645beb5b2945b7" => :el_capitan
    sha256 "903eb564fe6c91ccd7926884670527f9de2a422ab66141a296f507a1533aec94" => :yosemite
    sha256 "903eb564fe6c91ccd7926884670527f9de2a422ab66141a296f507a1533aec94" => :mavericks
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
