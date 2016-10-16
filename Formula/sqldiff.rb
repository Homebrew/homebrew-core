class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2016/sqlite-src-3150000.zip"
  version "3.15.0"
  sha256 "c68a7064b1932aa8c40f9b1e644ab899771530e16d514ba4a065434666d4a3a2"

  bottle do
    cellar :any_skip_relocation
    sha256 "ebd61b77192fb75be0d02b3786fc0cf4211ae1f047c9852da51e63320ba6b45b" => :sierra
    sha256 "b5c458d76b6b526c4df4af1e9bad2a72d99d5b1c356589cf182003bfbbddc34f" => :el_capitan
    sha256 "1a62ba5f9eac9e8fe5b8c388dca7cacf4fadb2bad6e42855cd6e8348cb6fc2b7" => :yosemite
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
