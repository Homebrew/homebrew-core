class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2017/sqlite-src-3160000.zip"
  version "3.16.0"
  sha256 "9aa6c30e350e3f9729ea56a63b5ec7eb7e5cd63ca63b34fa6784b7800ce25ad0"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd5171c6f413b48217c8ff48f6aec6ca91530ebfa262d1435b34775b00102f5e" => :sierra
    sha256 "83ac51e8de1a8194ac97919a33802a80a17b503187a4be6aeab4b06484c7d957" => :el_capitan
    sha256 "e1e71a7f621a05e5be7fc18b0f8b794a4fc7af3d37750c281d5b3027ddfb76de" => :yosemite
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
