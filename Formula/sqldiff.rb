class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2018/sqlite-src-3260000.zip"
  version "3.26.0"
  sha256 "e042825ba823d61db7edc45e52655c0434903a1b54bbe85a55880c9aa5884f7b"

  bottle do
    cellar :any_skip_relocation
    sha256 "070850ae9af4ae3bfa29dfebf6cfc6b392db66eadb1222d7372c4ade50a24959" => :mojave
    sha256 "56d0ddecb620ebae3e1abffec56ea4489ed8b9543059dee7763e04938f519de8" => :high_sierra
    sha256 "3dc28211099d6381e78cd3a715f4e220639a11168ea0e4e13fae50ac2af693c7" => :sierra
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
