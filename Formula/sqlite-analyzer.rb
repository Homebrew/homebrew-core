class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2019/sqlite-src-3300100.zip"
  version "3.30.1"
  sha256 "4690370737189149c9e8344414aa371f89a70e3744ba317cef1a49fb0ee81ce1"

  bottle do
    cellar :any_skip_relocation
    sha256 "45c49ba7c7771948f57f8c3d2113442cc03b68fa35851dde6212db0c7964eb83" => :catalina
    sha256 "c780dc644a7c5120228009cefbce2eb8fce057ff4922e38e5ffcf977f2f83965" => :mojave
    sha256 "6ece6a38bf34ae3b1785a8834e75989e39bd5c777e5f0ab7be7cf09d412cfaed" => :high_sierra
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
