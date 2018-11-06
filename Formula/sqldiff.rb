class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2018/sqlite-src-3250300.zip"
  version "3.25.3"
  sha256 "c7922bc840a799481050ee9a76e679462da131adba1814687f05aa5c93766421"

  bottle do
    cellar :any_skip_relocation
    sha256 "fed01dbf8f2df1624b7432b3e9d3dc78c2ff2bb9c6b27a28234a090c8d3bf576" => :mojave
    sha256 "0bcde5d2bef7b53c8c81537c816951d2a4ca28d1ae5c897a417fba7cb1053ae2" => :high_sierra
    sha256 "e63852385c00053abadaf4c4d502634c35e967db53ed28af01614e943f9a09ca" => :sierra
  end

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
