class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2019/sqlite-src-3280000.zip"
  version "3.28.0"
  sha256 "905279142d81c23e0a8803e44c926a23abaf47e2b274eda066efae11c23a6597"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b2532e7514225c620704f73af881043133876e4ed29feb2d410babafc373fe7" => :mojave
    sha256 "94986e3ebf559e52989597b04f8bb7b1223f37288bc163f1b2d96814eafacbd5" => :high_sierra
    sha256 "b934666b080488d6847ce791c68a409365df88e3e2021ad3a94f048eebe02088" => :sierra
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
