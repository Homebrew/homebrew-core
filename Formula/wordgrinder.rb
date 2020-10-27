class Wordgrinder < Formula
  desc "Unicode-aware word processor that runs in a terminal"
  homepage "https://cowlark.com/wordgrinder"
  url "https://github.com/davidgiven/wordgrinder/archive/0.8.tar.gz"
  sha256 "856cbed2b4ccd5127f61c4997a30e642d414247970f69932f25b4b5a81b18d3f"
  head "https://github.com/davidgiven/wordgrinder.git"

  bottle do
    cellar :any
    sha256 "34217b351fac13fc71bdcf99757e27547d31b028720ede8cff75dd8df98d731b" => :catalina
    sha256 "044ee7c9874894b65e2b407e38fef047dae2277f8bb4ad85e927f038612cfa82" => :mojave
    sha256 "7fe55fe2030606991d37ca2d0541674e3761e17dc02192ab62e54e8fceaec3f0" => :high_sierra
  end

  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"
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
