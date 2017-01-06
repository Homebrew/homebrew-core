class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2017/sqlite-src-3160200.zip"
  version "3.16.2"
  sha256 "ee77c2cc5cc4a7b0a746a1d4496f7aee0d71c558a3bbfcf8e9e0b35416910337"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4f795530609ebc40d6c9712207b20c6d96015bfbf6b5f2de296a23b86ab95ae" => :sierra
    sha256 "9e7ba04fdeecd0be2eed6216d42b08b28f447d0bab3a6976998201b750d2406e" => :el_capitan
    sha256 "1ddb360a36a65fb56c31aa79326ffc324785d6e6fc5f18cf91c517040b5f8d8a" => :yosemite
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
