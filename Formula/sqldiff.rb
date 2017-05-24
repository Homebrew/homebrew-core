class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2017/sqlite-src-3190100.zip"
  version "3.19.1"
  sha256 "4b8b3db73bf63ab35d4a07fe54667a7bc770ede2cf38e6ca2d88536e207034fc"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a56eabc8ffe68c192e6b0e48a2c28e480918fc5e83f277b38ff511b704b6ff9" => :sierra
    sha256 "c8333bbbe64dc2a3037f4283a8d969293cfc42163cccf61b6cc27cbb2eef89c4" => :el_capitan
    sha256 "8cc52c2bd600ffec23958c4d2d696d22df1bda789bb6f67643f859e607483949" => :yosemite
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
