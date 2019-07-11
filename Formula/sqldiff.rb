class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2019/sqlite-src-3290000.zip"
  version "3.29.0"
  sha256 "a1533d97504e969ca766da8ff393e71edd70798564813fc2620b0708944c8817"

  bottle do
    cellar :any_skip_relocation
    sha256 "88117606672c2d1fdbecda0bf146904ce7fca255fd02aa79c3e5ad6b14da8df6" => :mojave
    sha256 "7579818c8e67ce7bf7cfb3c90d2b0b8a8fd16937225522e1b0984f792b518cad" => :high_sierra
    sha256 "d8aea5d8388914d8a9435bcb69b0d21cf818e645f24fc57781c3c16a788005ed" => :sierra
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
