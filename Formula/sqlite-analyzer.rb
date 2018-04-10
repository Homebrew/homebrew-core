class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2018/sqlite-src-3230100.zip"
  version "3.23.1"
  sha256 "2db45af989d8c61cb7e179b64e2d48878336428c8c8c379b4594e8861aca7dfc"

  bottle do
    cellar :any_skip_relocation
    sha256 "a011ea94fd7addbdded55b4fdbdd37a6162d07b1f1cea25cc8c73e00cc1c059a" => :high_sierra
    sha256 "ddbae05a3f83932abaad40e0b6e86dffd7553d5b2a40e0df232acf5d2e9793f1" => :sierra
    sha256 "f48cb03411cae76b72c18c9983fccb84a0eca73ce2512256c97eb112cb64fdfd" => :el_capitan
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
