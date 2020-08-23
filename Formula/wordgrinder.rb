class Wordgrinder < Formula
  desc "Unicode-aware word processor that runs in a terminal"
  homepage "https://cowlark.com/wordgrinder"
  url "https://github.com/davidgiven/wordgrinder/archive/0.7.2.tar.gz"
  sha256 "4e1bc659403f98479fe8619655f901c8c03eb87743374548b4d20a41d31d1dff"
  revision 1
  head "https://github.com/davidgiven/wordgrinder.git"

  bottle do
    cellar :any
    sha256 "79fa0f89e7e123f7746ab934514834eaaecd35fa228a64e243d620825e508f7d" => :catalina
    sha256 "daa17cb7ea4b7ad382352a18b359deaa7f1a9cd8b2c7c8949b2f6dca41f0674c" => :mojave
    sha256 "735f8f1c7d405d11e0fd464d937d3f943c192c939126ca610a388f145da1a7da" => :high_sierra
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
