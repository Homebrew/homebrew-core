class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2016/sqlite-src-3150100.zip"
  version "3.15.1"
  sha256 "423a73936931c5148a4812ee7d82534ec7d998576ea1b4e1573af91ec15a4b01"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c5eda120ae4d0de4fb7d3ff9e304bf07526c9283b636034c1310a8fdb948d7b" => :sierra
    sha256 "53305996c55bda24f02b4c7974950b6cca35d05231e7b0a35c0e7ca97c53716f" => :el_capitan
    sha256 "afb630357759cb15085409243f8b30ad348a78f1e6ebfea64f5ea58d23f0cb70" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
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
