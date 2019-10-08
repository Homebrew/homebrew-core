class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2019/sqlite-src-3300100.zip"
  version "3.30.1"
  sha256 "4690370737189149c9e8344414aa371f89a70e3744ba317cef1a49fb0ee81ce1"

  bottle do
    cellar :any_skip_relocation
    sha256 "9de57d5f8b8987ac1ce43bdb33ec5828de8a9703622e947910823b91b6be62f8" => :catalina
    sha256 "3e735bcfea41e0f5f0926e08eff62fb73ac2b8a437b91e6ec8beeb695f6aef92" => :mojave
    sha256 "b17c9aa91489f090ccf743e212378d981b1b343171bf81e944310300e96ca443" => :high_sierra
    sha256 "b16e9dd0f1d5cbb97fe6c709768777bd5de338a4a2f7d085bcc2b34b8e90d1c5" => :sierra
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
