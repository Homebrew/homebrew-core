class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2017/sqlite-src-3200000.zip"
  version "3.20.0"
  sha256 "4b358e77a85d128651e504aaf548253ffe10d5d399aaef5a6e34f29262614bee"

  bottle do
    cellar :any_skip_relocation
    sha256 "79c9cdff6fe2ea2f6597ffd0e9002b2c0191f1605911a420772dda2dcc550abc" => :sierra
    sha256 "19908bc00b0656cf462f00913f74bf91bee1f37745863333a71f2b74c40ae102" => :el_capitan
    sha256 "d4f98a722fe0b7e0738f82d289c3225b4347c8c05ac2f14bcc6b9f026d85e94f" => :yosemite
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
