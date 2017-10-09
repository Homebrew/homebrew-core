class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2017/sqlite-src-3200100.zip"
  version "3.20.1"
  sha256 "665bcae19f313c974e3fc2e375b93521c3668d79bc7b66250c24a4a4aeaa2c2a"

  bottle do
    cellar :any_skip_relocation
    sha256 "783ed484e47fae7a4110ec8c651ca45670d594420bcef307e9b88ee96f037381" => :sierra
    sha256 "7d46ca521776e1835f55fe4eb3a83a5764a70422d8b1cbd8e4f788aa6dd428b4" => :el_capitan
    sha256 "0ae6a28f671a3eb7ef9dafa7f0616f33585e761a2f1bc6eff6bfd91b14ab0f83" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--with-tcl=/System/Library/Frameworks/Tcl.framework/", "--prefix=#{prefix}"
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
