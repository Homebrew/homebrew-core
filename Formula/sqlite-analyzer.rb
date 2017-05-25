class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2017/sqlite-src-3190200.zip"
  version "3.19.2"
  sha256 "899c370b162a3b1febc644be5363433789a629bd07f5f80231defb5603d1abc1"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9d9ca078a871a0c75a2e152ce0b80251b55d04741a0f720c4ba7cf25b62724c" => :sierra
    sha256 "22012584e186647dab169a4d5e66854a5f6bd6097486ea72bb3de1d98eee57a1" => :el_capitan
    sha256 "7f718c49cee7927f00b328726fdf559b6cadcad73752f26b69ff920013beac27" => :yosemite
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
