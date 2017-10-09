class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2017/sqlite-src-3200100.zip"
  version "3.20.1"
  sha256 "665bcae19f313c974e3fc2e375b93521c3668d79bc7b66250c24a4a4aeaa2c2a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "099327c9376093e2f764e3cd6b6f681395d305a4832a5ffde06fc3d43028604c" => :high_sierra
    sha256 "170ce3aff95cd073678b710d7616ddf0815c25354fc9e5f7e3dc36d3fc3d629d" => :sierra
    sha256 "87141adfe581826af5bb93023adc07662c16ad6fe3f7ea611c6004ce2f6c8080" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug", "--with-tcl=/System/Library/Frameworks/Tcl.framework/", "--prefix=#{prefix}"
    system "make", "sqlite3_analyzer"
    bin.install "sqlite3_analyzer"
  end

  test do
    dbpath = testpath/"school.sqlite"
    sqlpath = testpath/"school.sql"
    sqlpath.write <<-EOS.undent
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    EOS
    system "/usr/bin/sqlite3 #{dbpath} < #{sqlpath}"
    system bin/"sqlite3_analyzer", dbpath
  end
end
