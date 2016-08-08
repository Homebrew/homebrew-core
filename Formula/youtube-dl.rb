# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.08.07/youtube-dl-2016.08.07.tar.gz"
  sha256 "6f42477c562291cd392b7a034a7b828bbf1e209a48de7629848ba82a3aacdc1f"

  bottle do
    cellar :any_skip_relocation
    sha256 "519b2a24304e390beb4c4420c8e267ce51361a4348a16f9660023c5d39dbbfed" => :el_capitan
    sha256 "eb7c352ac04cd8f1714c09e208dafb047a8b679284fd89c5834962cb9c022c8f" => :yosemite
    sha256 "d9b23a73eabcd8f8fccaf254b16a135c99f070e57dc7600c8ecd2e20db078211" => :mavericks
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
