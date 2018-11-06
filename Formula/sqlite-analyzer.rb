class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2018/sqlite-src-3250300.zip"
  version "3.25.3"
  sha256 "c7922bc840a799481050ee9a76e679462da131adba1814687f05aa5c93766421"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5fd2236acc102d2ca7853d56ce002b0ef2be2cc2356afa4c39e9b8c5bea2175" => :mojave
    sha256 "ba2f6823207b01315ec6f301e93d3c9a71dbf3f951b829313fd6adea122e5d29" => :high_sierra
    sha256 "962db606f112a627fa514536bdfe7a9b3244b2fa1c9caafe082ec3f24c82a532" => :sierra
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
