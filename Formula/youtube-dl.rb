# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.07.13/youtube-dl-2016.07.13.tar.gz"
  sha256 "16cda6c8151445b90d3c43412788ff0bb7176e7d7d2a4325642b0e8113249443"

  bottle do
    cellar :any_skip_relocation
    sha256 "bcae521f6b3600f32f77d367d9084c87c78886eeec893481bbb00212c1d6b5bc" => :el_capitan
    sha256 "58711582ee07fafb88e407812b8ede43e08afe82fbc3c9c0d63afdf893ee3467" => :yosemite
    sha256 "6be6d5b9b256eee677d2c5e9f878f5f5d7a46a4c572e361b085631f83a6bb3f0" => :mavericks
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
