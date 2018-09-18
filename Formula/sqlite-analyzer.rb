class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2018/sqlite-src-3250100.zip"
  version "3.25.1"
  sha256 "e62f41c0b4de6ea537b70dc24efc37bd56e39bf6ceefcef20a0542fd912d7fae"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a45a45edbd9da108d3a91ca9f79f1a7906578c3fde4a3814bdacd87a84fc2b5" => :mojave
    sha256 "4572d529684f2d71bf1e8d5d2f09aeea75b906fb4a2cc0489ff5a4a3b5e94050" => :high_sierra
    sha256 "da95c29b9e8e7133e6053ac58d3b560c92f5bd2c4d79c8cfe3b641824438b924" => :sierra
    sha256 "3524e5ccdc4354520b88565a5f6b6ecd006665ee84f4ccc5d160f78aafcac8ed" => :el_capitan
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
