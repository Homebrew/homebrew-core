class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2020/sqlite-src-3340000.zip"
  version "3.34.0"
  sha256 "a5c2000ece56d2de13c474658b9cdba6b7f2608a4d711e245518ea02a2a2333e"
  license "blessing"

  livecheck do
    url "https://sqlite.org/news.html"
    regex(%r{v?(\d+(?:\.\d+)+)</h3>}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c9eec1c36e293154323243fa5de45f6fc7b68c30a819559a4cf20c106b2e5cc1" => :big_sur
    sha256 "f19d9c0de62635d0bf72503ac50034b6ac7e35435dfb472ee26f7d7312687c92" => :catalina
    sha256 "b15a0707f6f59fe6ce472d0d7ae6ebd023087e86a24f5fdc176add7c7729c37a" => :mojave
    sha256 "bde4f49fa6c7ff36ce787f26638625e9f88b2735148ffe4f57e9b2aee286d516" => :high_sierra
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

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
