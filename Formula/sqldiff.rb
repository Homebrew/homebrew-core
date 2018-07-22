class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2018/sqlite-src-3240000.zip"
  version "3.24.0"
  sha256 "72a302f5ac624079a0aaf98316dddda00063a52053f5ab7651cfc4119e1693a5"

  bottle do
    cellar :any_skip_relocation
    sha256 "e761abe7be582d424ef6f3c9376ce4af95bc5eb44e194cd2c0b9042b6c384da9" => :high_sierra
    sha256 "2c22d4e508f81bc1db981e1dfe968dd3061bf26bcb4d14d9cb353991614b4c2f" => :sierra
    sha256 "34898518763b5af1e0354c7c011ba34be0cb32c2d214b449ba61dde6b7b8149f" => :el_capitan
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
