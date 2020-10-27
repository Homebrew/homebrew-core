class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2020/sqlite-src-3330000.zip"
  version "3.33.0"
  sha256 "90bf7604a5aa26deece551af7a665fd4ce3d854ea809899c0e4bb19a69d609b8"
  license "blessing"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e59b093b696037bde52e57a1993961dde8233fbb7305157da8be0e54a986804" => :catalina
    sha256 "c76502517f95848e816532390f2b9a49b0a49b304da4b534bf299161a94d60ce" => :mojave
    sha256 "b43f737792c6eaaa3cb36af271d37bbb50e8f1232614ae38c314b84411616bc1" => :high_sierra
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
