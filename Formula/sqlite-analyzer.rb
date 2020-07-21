class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2020/sqlite-src-3320300.zip"
  version "3.32.3"
  sha256 "9312f0865d3692384d466048f746d18f88e7ffd1758b77d4f07904e03ed5f5b9"
  license "blessing"

  bottle do
    cellar :any_skip_relocation
    sha256 "be0fcfd67c24d3535357a3296999260b2c59b44d30d9a83c3a24cbe66788d0e7" => :catalina
    sha256 "c6a7f51142667d93c76f3a7526c2e01ecdbe3bc247aa023ebdbe1b84a7cf8132" => :mojave
    sha256 "ff7a59898e5cd9a077038e410f3e6c947c1583b67543ba9139962a716ecbc4e4" => :high_sierra
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
