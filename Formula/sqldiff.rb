class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2017/sqlite-src-3180000.zip"
  version "3.18.0"
  sha256 "eab4d137abd5aa1164244a5d558c9a02122071daf36984b236f8441d749b9ba6"

  bottle do
    cellar :any_skip_relocation
    sha256 "173d9e1e7b6a4250a217fe289006ab3cea34293b9decf72921e26ccc2b6f707c" => :sierra
    sha256 "cac6792d8703736db85d08ec8b388d1854714389282ee8f2d31b4470cf0404f1" => :el_capitan
    sha256 "d852a912a7611d03f964d3d35477a51fd76181f8ad10839f6e32844ac2e0a1e2" => :yosemite
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
