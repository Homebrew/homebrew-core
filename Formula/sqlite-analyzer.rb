class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2017/sqlite-src-3200000.zip"
  version "3.20.0"
  sha256 "4b358e77a85d128651e504aaf548253ffe10d5d399aaef5a6e34f29262614bee"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e5a9bc4d8e39eef480d2ff6626556372fcd23c5681998969529d516a066da0d" => :sierra
    sha256 "4dc7291b2bf2fa2ddf84290e30e0870816089417f51c2c9533ac189d4ad429e1" => :el_capitan
    sha256 "bcfe976a2389731fabb34e01dc251b32671056c0a36a4ac4fc14e753acce2155" => :yosemite
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
