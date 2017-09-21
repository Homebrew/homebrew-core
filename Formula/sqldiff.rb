class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2017/sqlite-src-3200100.zip"
  version "3.20.1"
  sha256 "665bcae19f313c974e3fc2e375b93521c3668d79bc7b66250c24a4a4aeaa2c2a"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b9922fec5c0bfc0b08d3efc8aec7badacc2e07c5edcf0ea3e0cd7a9d9590451" => :high_sierra
    sha256 "67a4b6da7e64c1e74a42408d6d04b785d58daf45108c246082af51c66e22abd6" => :sierra
    sha256 "4b12465f402ee73f9d907b48bd5ae0b7b601de5085118e614fb9cea8d1920dbb" => :el_capitan
    sha256 "541a0ddf76800d895575c2c770a060435888b6dab863fcbbbcd255e8559c5d00" => :yosemite
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
