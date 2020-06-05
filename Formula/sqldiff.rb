class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2020/sqlite-src-3320200.zip"
  version "3.32.2"
  sha256 "e027dd65738eb03fa87d79075a0ec2db2d2c7ad8ebca9ad2a0e96e6612d210cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4e6fe4368fb691cce5b4cf028c857a36bab39cb462a411ebcf7b922aa692925" => :catalina
    sha256 "59b488ea2a2aee77ad1fa77b7345422e84dd936cf8bd82f6a8dc28e39db3b448" => :mojave
    sha256 "3ee631c59a9671ecd1f5ce1b8f939c157e1e9a8cf997b9097d21f9d2439308c3" => :high_sierra
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
