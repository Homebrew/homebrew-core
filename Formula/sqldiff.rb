class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2020/sqlite-src-3320200.zip"
  version "3.32.2"
  sha256 "e027dd65738eb03fa87d79075a0ec2db2d2c7ad8ebca9ad2a0e96e6612d210cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf45bae7a867b985bae690cec09c87f511fa06b86c4b197d574b24e3e61bf196" => :catalina
    sha256 "c1fb02b6350f3de195069700022276a6374ed805f3f573782b3dfc457c276cb6" => :mojave
    sha256 "0470d4c41cb459d1e9d8bf4e8d84c238015b5dc5e3a0432129ddbbba42ea1b25" => :high_sierra
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
