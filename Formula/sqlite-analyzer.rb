class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2021/sqlite-src-3340100.zip"
  version "3.34.1"
  sha256 "dddd237996b096dee8b37146c7a37a626a80306d6695103d2ec16ee3b852ff49"
  license "blessing"

  livecheck do
    url "https://sqlite.org/news.html"
    regex(%r{v?(\d+(?:\.\d+)+)</h3>}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a1910f492d1443ce88ea36e03805af261ff73ea092f51ab1dfd481f3facc0e3d" => :big_sur
    sha256 "ed0ab0108b049069e69d292b36574debb3345a5f23bf3765acbfc2f0cddf95d6" => :arm64_big_sur
    sha256 "9e123d6cbf0a3ed7db12b44aaae12d8eadca9a62d7d9f547bd7417a3d255dec0" => :catalina
    sha256 "67fa646395cf0104c5dc4f50dfe4b492ba806d30a5f3a18d07a3d004283b3aa5" => :mojave
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
