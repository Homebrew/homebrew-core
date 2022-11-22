class Timewarrior < Formula
  desc "Command-line time tracking application"
  homepage "https://timewarrior.net/"
  url "https://github.com/GothenburgBitFactory/timewarrior/releases/download/v1.4.3/timew-1.4.3.tar.gz"
  sha256 "c4df7e306c9a267c432522c37958530b8fd6e5a410c058f575e25af4d8c7ca53"
  license "MIT"
  revision 1
  head "https://github.com/GothenburgBitFactory/timewarrior.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c4f3600fcb3b1dd5362a38b632e608c4cadee3ebb19540d73ca15dd72f7d617"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cced545d9ef04f31478f246a050d6f25e1263fa73d649f8c59618d593a4b8cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9dc622b28df1e1f069f11fc3e120f2c80183591542a01a01f8cf0df5a1e5febb"
    sha256 cellar: :any_skip_relocation, ventura:        "438ebff6691042d2ff1cbc84a425c9630de96a53031357f22d1fb4994d087d0c"
    sha256 cellar: :any_skip_relocation, monterey:       "fd2a0160dc34d555396caf6f194a37f216ab907047228d7db420a9e09d84418b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b150f7a94f536990782fcbc22bbc8301b442dc949d6227c669de10c48228b019"
    sha256 cellar: :any_skip_relocation, catalina:       "ea6624a0a220cf2d0499d52f88ab03e783d4d04ec7a601e4458463094cfb305c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c52deed21410b829bc9ba640e09138f9f39f210b831973a5421e6c47e296de81"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build

  on_linux do
    depends_on "man-db" => :test
  end

  fails_with gcc: "5"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/".timewarrior/data").mkpath
    (testpath/".timewarrior/extensions").mkpath
    touch testpath/".timewarrior/timewarrior.cfg"
    man = OS.mac? ? "man" : "gman"
    system man, "-P", "cat", "timew-summary"
    assert_match "Tracking foo", shell_output("#{bin}/timew start foo")
  end
end
