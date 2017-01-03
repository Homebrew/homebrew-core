class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2017/sqlite-src-3160100.zip"
  version "3.16.1"
  sha256 "490f0c27dd29cbc96df5b6750dcef18a9da5e31b3608fc241354f38d7af0a942"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc7f9dd52dc01117579def6930981e12d8833c10025f48c2e66f28ef996c94d0" => :sierra
    sha256 "347516c1e66a9608e3039a23a7d27fe00bbb705963a381b1e36901e790c3da26" => :el_capitan
    sha256 "638d2537947e3000b32a302022c51333479c86f98bf9ff418a4340e1a0d17796" => :yosemite
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
