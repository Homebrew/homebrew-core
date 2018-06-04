class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2018/sqlite-src-3240000.zip"
  version "3.24.0"
  sha256 "72a302f5ac624079a0aaf98316dddda00063a52053f5ab7651cfc4119e1693a5"

  bottle do
    cellar :any_skip_relocation
    sha256 "7cb8f36e207d850403274875212448e0741e17f8310d50ca8e8f691c5453decb" => :high_sierra
    sha256 "883497b8baff66489e56e8c23aa314e5dafeff224ac9c803805c5cd6d59902a3" => :sierra
    sha256 "e0ba9200fbc43e39af167800d19ab7f4ba14279fe14127ed451093871d889c59" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug", "--with-tcl=/System/Library/Frameworks/Tcl.framework/", "--prefix=#{prefix}"
    system "make", "sqlite3_analyzer"
    bin.install "sqlite3_analyzer"
  end

  test do
    dbpath = testpath/"school.sqlite"
    sqlpath = testpath/"school.sql"
    sqlpath.write <<~EOS
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    EOS
    system "/usr/bin/sqlite3 #{dbpath} < #{sqlpath}"
    system bin/"sqlite3_analyzer", dbpath
  end
end
