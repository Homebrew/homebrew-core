class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://yt-dl.org"
  url "https://files.pythonhosted.org/packages/12/8b/51cae2929739d637fdfbc706b2d5f8925b5710d8f408b5319a07ea45fe99/youtube_dl-2020.9.20.tar.gz"
  sha256 "67fb9bfa30f5b8f06227c478a8a6ed04af1f97ad4e81dd7e2ce518df3e275391"
  license "Unlicense"

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
