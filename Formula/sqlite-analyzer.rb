class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2017/sqlite-src-3210000.zip"
  version "3.21.0"
  sha256 "8681a34e059b30605f611ac85168ca54edbade50c71468b5882f5abbcd66b94e"

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
