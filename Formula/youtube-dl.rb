class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://yt-dl.org"
  url "http://abf-downloads.openmandriva.org/ytdl/youtube-dl-2020.09.20.tar.gz"
  sha256 "ead79e9248aaf7667f015da2ccd4bde44a8948fa980f82965609cdca88ad285e"
  license "Unlicense"
  
  #HEAD is disabled as https://github.com/ytdl-org/youtube-dl/ is taken down due to DMCA takedown notice by RIAA (https://github.com/github/dmca/blob/master/2020/10/2020-10-23-RIAA.md).
  #head do
  #  url "https://github.com/ytdl-org/youtube-dl.git"
  #  depends_on "pandoc" => :build
  #end

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
