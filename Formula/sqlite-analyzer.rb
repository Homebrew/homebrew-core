class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2016/sqlite-src-3140100.zip"
  version "3.14.1"
  sha256 "9411f67f383256d8d1520bac727b9e96eed5494222d2f8af76548d233b0adc74"

  bottle do
    cellar :any_skip_relocation
    sha256 "cfd041b1c6bda6f59d85cbf9795ccd8fb174b974e2cae454bf41914cbab1488c" => :el_capitan
    sha256 "fda5b349dd248f4ad1c611b40f7e93c48e299180c942e91d4b24b006d0d3768c" => :yosemite
    sha256 "f0803172a5e27e918ba83d3c5e7cd6905bd2ef6cf7548be1bc7a6ba37dd40862" => :mavericks
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
