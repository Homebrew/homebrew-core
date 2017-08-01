class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2017/sqlite-src-3200000.zip"
  version "3.20.0"
  sha256 "4b358e77a85d128651e504aaf548253ffe10d5d399aaef5a6e34f29262614bee"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7144d517abf89893e9cd9a17111e28807a8ff11be1dbbe0826890ed2a267dcc" => :sierra
    sha256 "1b03a3a116344ff1a496655aaf6ab7bc7ad60b38396d4257e5358d5dff7f1f2b" => :el_capitan
    sha256 "d9a18d50688253cf9914fc3c8779a6184de8af7852c8d90921b61f96e14dd627" => :yosemite
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
