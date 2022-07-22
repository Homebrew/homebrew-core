class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2022/sqlite-src-3390200.zip"
  version "3.39.2"
  sha256 "e933d77000f45f3fbc8605f0050586a3013505a8de9b44032bd00ed72f1586f0"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29f24cfe7960f1fe71a1b74b7ae83e2249d78982efc3f75911ffb8e3337c1266"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf434836d8b579e565893d3047d1d6266b917d8feac1f80e991dbaf0abc6a31c"
    sha256 cellar: :any_skip_relocation, monterey:       "9d8f644764184570a449cafb024d4b548b25d4a9afe4ac529d65a381d2951c88"
    sha256 cellar: :any_skip_relocation, big_sur:        "dcf376eaa73c8ef17e46cdd759df7d3655266d64278bdc8092b95110190f23bc"
    sha256 cellar: :any_skip_relocation, catalina:       "91690f582cdfe95b30dcabee73afdfaf24b470e47c0301a34c663f42519af3d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8c38ab30b0b3b1d5d794c4d10f996e58f09a8b9577a11d950dc6a4405cf0131"
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "sqldiff"
    bin.install "sqldiff"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "test: 0 changes, 0 inserts, 0 deletes, 0 unchanged",
                 shell_output("#{bin}/sqldiff --summary #{dbpath} #{dbpath}").strip
  end
end
