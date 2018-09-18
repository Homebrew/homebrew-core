class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2018/sqlite-src-3250100.zip"
  version "3.25.1"
  sha256 "e62f41c0b4de6ea537b70dc24efc37bd56e39bf6ceefcef20a0542fd912d7fae"

  bottle do
    cellar :any_skip_relocation
    sha256 "2bbc0ac22a67bbc7beb2e6be1ce01d868d531118376d3dfdd9cb1d9990ea1466" => :mojave
    sha256 "cc34d883a062d87c096e7706a4987666c956a6c6cc06ce98cf240a684a6049bd" => :high_sierra
    sha256 "c6e110a0e835722b5ac913e63cb2bedf1643f69b895302b218fc18a8e6d6ff36" => :sierra
    sha256 "2190a9bff9e470ab21ea9eb59fb6c5a14bd96dd799cd3776c8328f729b2448a6" => :el_capitan
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
