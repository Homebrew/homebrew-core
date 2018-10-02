class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2018/sqlite-src-3250200.zip"
  version "3.25.2"
  sha256 "80a46070dacef0a90b535d713556e46e930865501d8dd09df93df470ccfdf458"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b4b4c7700d76bfeafaa26622c5c00b742bd6953772eb209af62c2ada50420fc" => :mojave
    sha256 "e692ab15abb154392cf0aeac0f698243de2efd885a7f11d38373a891bb84154a" => :high_sierra
    sha256 "155d14684fd6f58227c87b4f6a4ccf5db6d44d60ff55fc202ed6538ef988cbe6" => :sierra
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
