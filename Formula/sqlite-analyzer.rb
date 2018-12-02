class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2018/sqlite-src-3260000.zip"
  version "3.26.0"
  sha256 "e042825ba823d61db7edc45e52655c0434903a1b54bbe85a55880c9aa5884f7b"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9e6a16dd9ded73db02722a802797c3c7cf9555d828462cae2f33d51c5c118e0" => :mojave
    sha256 "76c127180a78cdc88ab9525a7968c80bd0b96dbded1a79d2e3f66d83cdbcc7b6" => :high_sierra
    sha256 "196e2be7620473c285d137e00ce2a8a0c5f1549a2eb1d7d1bb56278993d13396" => :sierra
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
