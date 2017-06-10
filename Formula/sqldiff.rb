class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2017/sqlite-src-3190300.zip"
  version "3.19.3"
  sha256 "5595bbf59e7bb6bb43a6e816b9dd2ee74369c6ae3cd60284e24d5f7957286120"

  bottle do
    cellar :any_skip_relocation
    sha256 "f2bf0f1f7aff6054d153318c665d00b4be22f8b1acb3cf2f850a6e7da0e11423" => :sierra
    sha256 "b92733f83ad38b5ec15292cfc694a6d1477c01e2bece6b229c4a53124024a33f" => :el_capitan
    sha256 "38b48738e33029d7d438180d26c176c4333c03ed2b86bb3fd69aadc33afb0e05" => :yosemite
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
