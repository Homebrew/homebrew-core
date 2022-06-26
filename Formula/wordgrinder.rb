class Wordgrinder < Formula
  desc "Unicode-aware word processor that runs in a terminal"
  homepage "https://cowlark.com/wordgrinder"
  url "https://github.com/davidgiven/wordgrinder/archive/0.8.tar.gz"
  sha256 "856cbed2b4ccd5127f61c4997a30e642d414247970f69932f25b4b5a81b18d3f"
  license "MIT"
  revision 1
  head "https://github.com/davidgiven/wordgrinder.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3eb4bf8cff526d9a6e6c9e285ba2a63879eb157a6ba091dff6be7ad49da749b3"
    sha256 cellar: :any,                 arm64_big_sur:  "370093b3705f72a5d6b87bacd2e64e229f3d6ac82e52e92fe147c037d65f210b"
    sha256 cellar: :any,                 monterey:       "2ab17d2541132790b1b134a5d33e5e9178ce96b7afeadf28819a9694f87712da"
    sha256 cellar: :any,                 big_sur:        "d2cb8d569e0a7a02abae8deb32adf8a564042cfd6cddaeef4bc1dc16ab05e53b"
    sha256 cellar: :any,                 catalina:       "e084da6193fd984ac541e7c21044f80927b60b85ab69512d3824255be1c54d17"
    sha256 cellar: :any,                 mojave:         "143c53429552e244089211458fc42bcdbb79171d5f98ae17db9c7175208c8ae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07fdfa2bd3da72697fbd54cc93a8bc59b2c3afc3ddbfd55a46cde0e557011ca4"
  end

  depends_on "lua" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "ncurses"

  uses_from_macos "zlib"

  def install
    ENV["CURSES_PACKAGE"] = "ncursesw"
    system "make", "OBJDIR=#{buildpath}/wg-build"
    bin.install "bin/wordgrinder-builtin-curses-release" => "wordgrinder"
    man1.install "bin/wordgrinder.1"
    doc.install "README.wg"
  end

  test do
    system "#{bin}/wordgrinder", "--convert", "#{doc}/README.wg", "#{testpath}/converted.txt"
    assert_predicate testpath/"converted.txt", :exist?
  end
end
