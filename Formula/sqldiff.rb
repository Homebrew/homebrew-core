class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2018/sqlite-src-3220000.zip"
  version "3.22.0"
  sha256 "7bc5a3ce285690db85bd3f97034a467e19096b787c9c9c09a23b1513a43c8913"

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
