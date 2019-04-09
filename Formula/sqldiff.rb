class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2019/sqlite-src-3270200.zip"
  version "3.27.2"
  sha256 "15bd4286f2310f5fae085a1e03d9e6a5a0bb7373dcf8d4020868792e840fdf0a"

  bottle do
    cellar :any_skip_relocation
    sha256 "b72832399179459b66654e3b2bb98a069178ee15b80cabe288805e564ebcb7f0" => :mojave
    sha256 "d9936865965b6a8923e93aaddf228362e1b95f5d00cc5ce0bb97bc413a9ae235" => :high_sierra
    sha256 "558d9d8394c83fd102eff803c685c9516157d2298b2e1c50194ddf9bd329ad3b" => :sierra
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
