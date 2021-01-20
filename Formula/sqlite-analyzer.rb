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
    sha256 "94fcffd969fb353677861b33e1d1cbf4d06c267711d7ec7f15d96b6e8d7707cf" => :big_sur
    sha256 "673eee1fdf609fd1ed3ee8887646d2188d0e3f1718efae62e7e43fb1998c3c20" => :arm64_big_sur
    sha256 "07b188e4a46c429622a1b89d4fba852bd337fc9c522278c6ef8d8137cf99f199" => :catalina
    sha256 "ae6550708b62b3c03d3ef760294fc9271e0b469286324bcdb01d99458d282fd5" => :mojave
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
