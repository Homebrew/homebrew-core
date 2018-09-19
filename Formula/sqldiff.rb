class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2018/sqlite-src-3250100.zip"
  version "3.25.1"
  sha256 "e62f41c0b4de6ea537b70dc24efc37bd56e39bf6ceefcef20a0542fd912d7fae"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6d77dff0537bbfa3baf9d3fde2b81c666d30d781aff889193426f9258676a94" => :mojave
    sha256 "241fe08f9118845fbc38fe23977a7b5286471384f4469a13d45f813e34b7f326" => :high_sierra
    sha256 "9650069dba06edd11e3dec15ab98dbc8af69d0cef1922d2e1cb4c5e1bc8772c0" => :sierra
    sha256 "78119a34e5b1102e323098cd3150528cfa5c48ca5422ce763774d662f1962863" => :el_capitan
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
