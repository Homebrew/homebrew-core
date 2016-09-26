class Sqldiff < Formula
  desc "Displays the differences between SQLite databases."
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2016/sqlite-src-3140200.zip"
  version "3.14.2"
  sha256 "52507e20c2757b24b703b43ede77ce464c8106c1658a5b357974c435aa0677a6"

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
    assert_equal "test: 0 changes, 0 inserts, 0 deletes, 0 unchanged", shell_output("#{bin}/sqldiff --summary #{dbpath} #{dbpath}").strip
  end
end
