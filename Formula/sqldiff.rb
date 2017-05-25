class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2017/sqlite-src-3190200.zip"
  version "3.19.2"
  sha256 "899c370b162a3b1febc644be5363433789a629bd07f5f80231defb5603d1abc1"

  bottle do
    cellar :any_skip_relocation
    sha256 "f25ffaaf437c425b2fc648d8eb9d8bbe33048bb33c6e4d7b18a4de3f4aa40948" => :sierra
    sha256 "4a0462d51e2b0df584c2c9e4260ebd461e2d4d838c2da93b3702c9e8c378794d" => :el_capitan
    sha256 "1931cc35400cf0f07120d3de1272a9714337de761f1770d486d86bf451f8e201" => :yosemite
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
