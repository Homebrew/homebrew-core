class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2017/sqlite-src-3160000.zip"
  version "3.16.0"
  sha256 "9aa6c30e350e3f9729ea56a63b5ec7eb7e5cd63ca63b34fa6784b7800ce25ad0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e1e83629bcc712a3cfd505d67a100ef21d5e4119b46f93cea99d20866960f4f" => :sierra
    sha256 "fa62f186ab11aa397f955f71a6c1985207fa7a0d0904e75f35fb468c121956f6" => :el_capitan
    sha256 "441db5987c513355deb582fb15a11a27ea9624ce423453f3d93fc8437468a716" => :yosemite
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
