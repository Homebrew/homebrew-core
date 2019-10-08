class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2019/sqlite-src-3300100.zip"
  version "3.30.1"
  sha256 "4690370737189149c9e8344414aa371f89a70e3744ba317cef1a49fb0ee81ce1"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ccdf2c56a73f41fed176042dbc9c8adbff0fcedef00fe94f73b6a1fc3269e52" => :catalina
    sha256 "ad8628c564822e587747c49e7d7db2e10011af14077f47094662d29745a2d98b" => :mojave
    sha256 "45710ca091f16bcb148d92f53b1aad0e049d0d49836529add96aadfe5ec53d6a" => :high_sierra
    sha256 "0a7c045d97ffbb2e6f767c4ea55c1fa294cd4f1d7e6ae66ba126739e6cb0e223" => :sierra
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
