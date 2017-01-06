class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2017/sqlite-src-3160200.zip"
  version "3.16.2"
  sha256 "ee77c2cc5cc4a7b0a746a1d4496f7aee0d71c558a3bbfcf8e9e0b35416910337"

  bottle do
    cellar :any_skip_relocation
    sha256 "d41327d86762fa98fb9297a9119c1721da3de536b2c674c5584410a99c1d3c34" => :sierra
    sha256 "a4bc1fcd51640ee862516474b0206565bd98625f9a5dae8b7567543c96e3bab8" => :el_capitan
    sha256 "bfc23821501b2de03e014bca0c56bfebc96578c380cfaa8fe2aa4075ce16324a" => :yosemite
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
