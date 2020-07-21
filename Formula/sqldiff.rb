class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2020/sqlite-src-3320300.zip"
  version "3.32.3"
  sha256 "9312f0865d3692384d466048f746d18f88e7ffd1758b77d4f07904e03ed5f5b9"
  license "blessing"

  bottle do
    cellar :any_skip_relocation
    sha256 "505cf291b499c91daa6613435ed54e1d19f6d84fa3bd7a664c8b60d2040125d0" => :catalina
    sha256 "430b27651e0dcdff06eae788c238b42a7ec4b2779eb3aaa7987287b6269e686f" => :mojave
    sha256 "29e1767b313f6983f2481077710ffbff2ebc71e48f31b855df12376df9b4bf6a" => :high_sierra
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
    system "/usr/bin/sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "test: 0 changes, 0 inserts, 0 deletes, 0 unchanged",
                 shell_output("#{bin}/sqldiff --summary #{dbpath} #{dbpath}").strip
  end
end
