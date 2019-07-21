class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2019/sqlite-src-3290000.zip"
  version "3.29.0"
  sha256 "a1533d97504e969ca766da8ff393e71edd70798564813fc2620b0708944c8817"

  bottle do
    cellar :any_skip_relocation
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
