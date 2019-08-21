class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2019/sqlite-src-3290000.zip"
  version "3.29.0"
  sha256 "a1533d97504e969ca766da8ff393e71edd70798564813fc2620b0708944c8817"

  bottle do
    cellar :any_skip_relocation
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
