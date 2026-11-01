class Ssocr < Formula
  desc "Seven Segment Optical Character Recognition"
  homepage "https://www.unix-ag.uni-kl.de/~auerswal/ssocr/"
  url "https://www.unix-ag.uni-kl.de/~auerswal/ssocr/ssocr-2.26.0.tar.bz2"
  sha256 "d58f60ece1951755e1355cd0eeeb9545318ac9bb067de6afd62598f9f4c9f406"
  license "GPL-3.0-or-later"
  head "https://github.com/auerswal/ssocr.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ssocr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "62f822e0b036dc740d3d55b3188502240bad69afbf4f8837c7e89450e1949ec1"
    sha256 cellar: :any, arm64_tahoe:       "9c5d02253b1109460215510129fbb505be2362076757262d70537ffe52fd9cbc"
    sha256 cellar: :any, arm64_sequoia:     "cb74530da366cbf89ed8d2b33a50ee663001f7e07674a2fadbb1de1bdba1bc51"
    sha256 cellar: :any, arm64_linux:       "410c6e6eef67d72360b16ab510b6e70cd7a818106437793ec9d5232b84e4c7a8"
    sha256 cellar: :any, x86_64_linux:      "40a26f67342a25a83f85ed55bf9ddfaad5904c8f9be80388857bb2e81470d8b9"
  end

  depends_on "pkgconf" => :build
  depends_on "imlib2"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # A seven-segment "431432"; drawn here because fetching a sample image hangs on some runners
    display = <<~DIGITS
      ..............#######..........................#######....#######...
      ..#.......#..........#..........#..#.......#..........#..........#..
      ..#.......#..........#..........#..#.......#..........#..........#..
      ..#.......#..........#..........#..#.......#..........#..........#..
      ..#.......#..........#..........#..#.......#..........#..........#..
      ..#.......#..........#..........#..#.......#..........#..........#..
      ...#######....#######...............#######....#######....#######...
      ..........#..........#..........#..........#..........#..#..........
      ..........#..........#..........#..........#..........#..#..........
      ..........#..........#..........#..........#..........#..#..........
      ..........#..........#..........#..........#..........#..#..........
      ..........#..........#..........#..........#..........#..#..........
      ..............#######..........................#######....#######...
    DIGITS

    rows = display.lines.map(&:chomp)
    (testpath/"digits.pbm").write <<~PBM
      P1
      #{rows.first.length} #{rows.length}
      #{rows.join("\n").tr(".#", "01")}
    PBM

    assert_equal "431432", shell_output("#{bin}/ssocr -T #{testpath}/digits.pbm").chomp
  end
end
