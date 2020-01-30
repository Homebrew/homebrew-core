class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2020/sqlite-src-3310100.zip"
  version "3.31.1"
  sha256 "f2dc2382855d99a960c363c1e5ae72b49da4c55d49154aa6d100e5970a1fee58"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c7c1d6b079bf9f336e8ea5e51347b7b07dc0370dd6daac8c33dd6bbbd0d0f12" => :catalina
    sha256 "0242ab486e5b376e568ce714c12911c979f276bcc4aab4e65d3a5924fa23e41e" => :mojave
    sha256 "1ea15eaf7c608d1cf7fb562a1581acce36b81862313fa8f743167322cb4e0297" => :high_sierra
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
