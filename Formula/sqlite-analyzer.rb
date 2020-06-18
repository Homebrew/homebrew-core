class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2020/sqlite-src-3320300.zip"
  version "3.32.3"
  sha256 "9312f0865d3692384d466048f746d18f88e7ffd1758b77d4f07904e03ed5f5b9"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea69081d08790744a643b195e323051654bad6e120d254936558504121531576" => :catalina
    sha256 "028b2c174d60974f851d4ab0bd9f1b39bae855d605e64de7c641b438da430eaa" => :mojave
    sha256 "d214900072db442cdc4b0c1e870a12a96872b23c98dd983f6799671acd1a02fc" => :high_sierra
  end

  def install
    sdkprefix = MacOS.sdk_path_if_needed ? MacOS.sdk_path : ""
    system "./configure", "--disable-debug",
                          "--with-tcl=#{sdkprefix}/System/Library/Frameworks/Tcl.framework/",
                          "--prefix=#{prefix}"
    system "make", "sqlite3_analyzer"
    bin.install "sqlite3_analyzer"
  end

  test do
    dbpath = testpath/"school.sqlite"
    sqlpath = testpath/"school.sql"
    sqlpath.write <<~EOS
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    EOS
    system "/usr/bin/sqlite3 #{dbpath} < #{sqlpath}"
    system bin/"sqlite3_analyzer", dbpath
  end
end
