class YoutubeDlc < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://blackjack4494.github.io/youtube-dlc/"
  url "https://github.com/blackjack4494/youtube-dlc/releases/download/2020.09.13/youtube-dlc"
  version "2020.09.13"
  sha256 "633caf38c990ab1b21cfe849151601e8a1548ddcdd539caf755e1b3d47941af9"
  license "Unlicense"

  # depends_on "cmake" => :build

  def install
    bin.install "youtube-dlc"
  end

  test do
    # commit history of homebrew-core repo
    system "#{bin}/youtube-dlc", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # homebrew playlist
    system "#{bin}/youtube-dlc", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
