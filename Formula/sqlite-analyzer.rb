class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2017/sqlite-src-3200000.zip"
  version "3.20.0"
  sha256 "4b358e77a85d128651e504aaf548253ffe10d5d399aaef5a6e34f29262614bee"

  bottle do
    cellar :any_skip_relocation
    sha256 "70945e6c252604c8cd9ae273689a28b6ab9a0df645ac61f49fd032caffdc3c1b" => :sierra
    sha256 "2c83b998a4dd9b3592e15290a36e8f1c10e113f1483089079d52da40fcb6c1a6" => :el_capitan
    sha256 "0ab64a58708a5a793cf28ddc62bb6ec68a2399e7bfc819b392d53c8365c66c56" => :yosemite
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
