class Vgrep < Formula
  desc "User-friendly pager for grep"
  homepage "https://github.com/vrothberg/vgrep"
  url "https://github.com/vrothberg/vgrep/archive/v2.5.5.tar.gz"
  sha256 "6272ca460549813231bc046e6fde7e94baec03f66c4b8f88b197af7d70556013"
  license "GPL-3.0-only"
  version_scheme 1
  head "https://github.com/vrothberg/vgrep.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "525f86fea0bdf137d5047f88a6040d629161135d960e51a710d5dc43feb8e78e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9cd68586cd3c4c8caff6123707a90caa752ede23051fec06f7f94345ce4b674"
    sha256 cellar: :any_skip_relocation, monterey:       "203bd584c29a7ac3d4eab481c01f53961cb921df433bf019aad075bd57c9e136"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc3ba7496ba5e93aa1ec4587fdf8d672602ebd4d0014a93f161b60218ec3c460"
    sha256 cellar: :any_skip_relocation, catalina:       "d53ef92d20ae9f34376be8a78f0dd19f9a570d1c7b823a67b3a2cff502445969"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  def install
    system "make", "release"
    mkdir bin
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.txt").write "Hello from Homebrew!\n"
    output = shell_output("#{bin}/vgrep -w Homebrew --no-less .")
    assert_match "Hello from \e[01;31m\e[KHomebrew\e[m\e[K!\n", output
  end
end
