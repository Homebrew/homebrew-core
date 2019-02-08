class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2019/sqlite-src-3270100.zip"
  version "3.27.1"
  sha256 "f0fcc4da31e61a9c516f7c1ff21ec71ad6a05b1fe88f7f0b4d9aa54649c85986"

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
