class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2018/sqlite-src-3230000.zip"
  version "3.23.0"
  sha256 "22422e1d34ecc21af5d374c328c540a3a6e32d7d6cf3c57be8b51b523b98d633"

  bottle do
    cellar :any_skip_relocation
    sha256 "b28c1bc5b4816fcf9f35272def95bc76c604c47686d8b0155daf6c928eb1a6d7" => :high_sierra
    sha256 "f39864a2d260412292f6a6093f1825020bdf8b623a026063671d7ed7c7add1fa" => :sierra
    sha256 "f1f9003beba2ceeb3932e47f12a79b7daacfa597181b2fb17fe4fefb9f0afa58" => :el_capitan
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
