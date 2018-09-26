class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2018/sqlite-src-3250200.zip"
  version "3.25.2"
  sha256 "80a46070dacef0a90b535d713556e46e930865501d8dd09df93df470ccfdf458"

  bottle do
    cellar :any_skip_relocation
    sha256 "093bc1acb938c5f228b491a056085d5f1834a8565de22ed4dab875d4f7396d73" => :mojave
    sha256 "e2a10063e5500f9ebe911f986742b1c7aacf777da1a53c006f395fa06e11b83b" => :high_sierra
    sha256 "6108b2cd3851df67afc36b37be727fda9f773958c02667a2e67ed4aa6b626373" => :sierra
    sha256 "d66d6ad4a9d4ebf2361f7e6afb9f4bca934438e27c4ee7879e7cd7c6b598b86b" => :el_capitan
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
