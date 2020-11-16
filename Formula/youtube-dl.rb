class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://github.com/ytdl-org/youtube-dl/releases/download/2020.11.12/youtube-dl-2020.11.12.tar.gz"
  sha256 "aeb00b2079c4711de7eea2a91f6923ebade84c5e985b0caeb47d572395d42831"
  license "Unlicense"
  revision 1

  head do
    url "https://github.com/ytdl-org/youtube-dl.git"
    depends_on "pandoc" => :build
  end

  bottle :unneeded

  def install
    system "make", "PREFIX=#{prefix}" if build.head?
    bin.install "youtube-dl"
    man1.install "youtube-dl.1"
    bash_completion.install "youtube-dl.bash-completion"
    zsh_completion.install "youtube-dl.zsh" => "_youtube-dl"
    fish_completion.install "youtube-dl.fish"
  end

  test do
    # commit history of homebrew-core repo
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # homebrew playlist
    system "#{bin}/youtube-dl", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
