class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2017/sqlite-src-3180000.zip"
  version "3.18.0"
  sha256 "eab4d137abd5aa1164244a5d558c9a02122071daf36984b236f8441d749b9ba6"

  bottle do
    cellar :any_skip_relocation
    sha256 "893afee1f93e28e25351b2b426490fb889494330d2547e63f0d45afd4da56040" => :sierra
    sha256 "e1d7234ef0a619c3b1653c29b204c9813e59b3ff6b0d2f15801c86847ef5af38" => :el_capitan
    sha256 "512ca3e4b923cdb65ff62c49608bd3b61df2e0bbbc1d4a50ca71131b3941b825" => :yosemite
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
