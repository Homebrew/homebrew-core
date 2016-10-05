class Sqldiff < Formula
  desc "Displays the differences between SQLite databases."
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2016/sqlite-src-3140200.zip"
  version "3.14.2"
  sha256 "52507e20c2757b24b703b43ede77ce464c8106c1658a5b357974c435aa0677a6"

  bottle do
    cellar :any_skip_relocation
    sha256 "de0d0f9add4b98bd62f94f37d6545a2a64a38ea018dd80839e29a39ca3f64a9e" => :sierra
    sha256 "c464cbc13adb7a8fc4824810aee5ca8e7d0b10e9857a2e85f60e66871900f299" => :el_capitan
    sha256 "4c2da93e7410f42a2c72634df29347b58141622fc3f4c863ae109015a812dfe6" => :yosemite
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
