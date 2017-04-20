class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2017/sqlite-src-3180000.zip"
  version "3.18.0"
  sha256 "eab4d137abd5aa1164244a5d558c9a02122071daf36984b236f8441d749b9ba6"

  bottle do
    cellar :any_skip_relocation
    sha256 "3258ee4efd3604023984e07e47cb1cbe76326841409193e02852cf0c574aca00" => :sierra
    sha256 "c5429fbad912aa185949be49f696c20c95ce394a2eead4b9eaa6505a0d553454" => :el_capitan
    sha256 "df74e8d60f4c5e295d3f4b1afee9b82434927553294772be8f047fd4ac0303d4" => :yosemite
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
