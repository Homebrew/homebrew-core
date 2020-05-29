class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2020/sqlite-src-3320100.zip"
  version "3.32.1"
  sha256 "5ccc7dd634ab820dbcef56318279d27ee945ccaba17e70d4932e5c624a7872d0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ffa0ee34ecd71318de1e58023266487018c630706c7e3aceb65bb4a5639b71f6" => :catalina
    sha256 "8c062ac8520efd770c8c53bd477f7e8c1d9a895654d312afdcb2b4f3c0cc3c8c" => :mojave
    sha256 "ea30e98927a4837ed7671bf1b114ef0bf420376f633f27e62771451156172a91" => :high_sierra
  end

  def install
    sdkprefix = MacOS.sdk_path_if_needed ? MacOS.sdk_path : ""
    system "./configure", "--disable-debug",
                          "--with-tcl=#{sdkprefix}/System/Library/Frameworks/Tcl.framework/",
                          "--prefix=#{prefix}"
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
