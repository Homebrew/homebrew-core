class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2018/sqlite-src-3240000.zip"
  version "3.24.0"
  sha256 "72a302f5ac624079a0aaf98316dddda00063a52053f5ab7651cfc4119e1693a5"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d05461e2599fd293f762e535e240890345e856bb0964ec2e133b4ab690afe59" => :high_sierra
    sha256 "6067e5f249724c8c0e0b51e3ee06597b17620f4351a75d442896d2b6d66b342e" => :sierra
    sha256 "de9b4a4e23eadd99cfffb15685a22dd820b21ff759ffb20aeff89771c8f5eef0" => :el_capitan
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
