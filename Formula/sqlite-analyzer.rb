class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2019/sqlite-src-3280000.zip"
  version "3.28.0"
  sha256 "905279142d81c23e0a8803e44c926a23abaf47e2b274eda066efae11c23a6597"

  bottle do
    cellar :any_skip_relocation
    sha256 "80eae86873120bd99f710f2f0b6f02600738420281a044456dcfd22bf1bb89cb" => :mojave
    sha256 "0166f9ad31ba5d44332f85b5f6d743d8c151d01cefd82e28c3f064939d78da16" => :high_sierra
    sha256 "3002b0a0940ec35224c9833a694fcbbf44a87d918d9b11bcfe2def5891ab2f8b" => :sierra
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
