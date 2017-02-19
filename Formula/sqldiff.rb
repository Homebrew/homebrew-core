class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2017/sqlite-src-3170000.zip"
  version "3.17.0"
  sha256 "86754bee6bcaf1f2a6bf4a02676eb3a43d22d4e5d8339e217424cb2be6b748c3"

  bottle do
    cellar :any_skip_relocation
    sha256 "173d9e1e7b6a4250a217fe289006ab3cea34293b9decf72921e26ccc2b6f707c" => :sierra
    sha256 "cac6792d8703736db85d08ec8b388d1854714389282ee8f2d31b4470cf0404f1" => :el_capitan
    sha256 "d852a912a7611d03f964d3d35477a51fd76181f8ad10839f6e32844ac2e0a1e2" => :yosemite
  end

  def install
    ENV.append "CPPFLAGS", "-DSQLITE_DISABLE_INTRINSIC" if MacOS.version <= :yosemite && ENV.compiler == :clang
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
