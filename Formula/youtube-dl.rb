# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.07.06/youtube-dl-2016.07.06.tar.gz"
  sha256 "29d17a782a5bff9a229d4166b2f0affb269c98f7d3d468b610240c83c14e6bfd"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2933015fca2647b99a86b22fece9c007f4eb2e916d0201c1f18d11211f23c95" => :el_capitan
    sha256 "e9d14fc4b9b765dca78093752ad958678328f68ec0e206fe9d673e24199422bf" => :yosemite
    sha256 "e5076909255df88a88637e2ac1f0f0557ea69cbc327588835db17d51dac67cbd" => :mavericks
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
