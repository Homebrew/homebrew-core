class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2017/sqlite-src-3160100.zip"
  version "3.16.1"
  sha256 "490f0c27dd29cbc96df5b6750dcef18a9da5e31b3608fc241354f38d7af0a942"

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
