class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2017/sqlite-src-3170000.zip"
  version "3.17.0"
  sha256 "86754bee6bcaf1f2a6bf4a02676eb3a43d22d4e5d8339e217424cb2be6b748c3"

  bottle do
    cellar :any_skip_relocation
    sha256 "52887455e4430fb5aba448495c5bb723ab634a3bc8a38ea41e21f132b63f0cfa" => :sierra
    sha256 "22fad066939d9d482e8209a354ac7f0464cbd6557c5fb081e39601872944053d" => :el_capitan
    sha256 "ad658e6db8b2e4e87a13244f4758ed1aa47e8151197e71b9207cd143fc0eaf20" => :yosemite
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
