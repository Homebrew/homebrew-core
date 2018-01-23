class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2018/sqlite-src-3220000.zip"
  version "3.22.0"
  sha256 "7bc5a3ce285690db85bd3f97034a467e19096b787c9c9c09a23b1513a43c8913"

  bottle do
    cellar :any_skip_relocation
    sha256 "355390b33568be35f2511a7cd3dd396956b161d145a7462afbf9f965d1a79354" => :high_sierra
    sha256 "08b838d551a9130a00bba8cb1f9726136b0f5df54a0693ee90748b6c1cc8e306" => :sierra
    sha256 "18736a9aa491a241f86a838392da67f6167d6b4f9d65722aa4f76a0a3916bb0b" => :el_capitan
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
