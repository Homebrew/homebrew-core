class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2020/sqlite-src-3310100.zip"
  version "3.31.1"
  sha256 "f2dc2382855d99a960c363c1e5ae72b49da4c55d49154aa6d100e5970a1fee58"

  bottle do
    cellar :any_skip_relocation
    sha256 "123b6cdeae53335ca3d3973c7c46818ae50a6a179c4428bec3572dc37f9f3955" => :catalina
    sha256 "ca23431b169cc686b62591bcc5bc330863f49ea5167c4c7a8e806403b533547e" => :mojave
    sha256 "da5c2ce46cc24f2d2e619befc977db5d702994259e5e31ae3bc8a41a46d9f37e" => :high_sierra
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
