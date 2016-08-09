class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2016/sqlite-src-3140000.zip"
  version "3.14.0"
  sha256 "97d5735dddfb74598a0694a0252e5b19caeac49f2fed30181598d2243b619abb"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ff658454a0eb8e762d493e7f971752f2a0649ea577ac66648c2826786f03bf2" => :el_capitan
    sha256 "cc96f57a0d0f828afe673d1bc59bd2bbd87bad09104d687cc6b16ebb91776785" => :yosemite
    sha256 "f3d56349ab1688b62e26271622cc1734604006b873b9913b1e9b490e328ba88a" => :mavericks
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
    system "#{bin}/sqlite3_analyzer", dbpath
  end
end
