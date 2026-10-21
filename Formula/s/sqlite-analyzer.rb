class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2026/sqlite-src-3540100.zip"
  version "3.54.1"
  sha256 "387e7f6cad4797b17848c07d453dc6606917bb356a6cfe5a3abafd38c240c71b"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f53f7a6dd5b6b29e48a5f8d9cd046fcc9b5086678594d2ad2b232ec42191949e"
    sha256 cellar: :any, arm64_tahoe:       "c2709a1c058a4f2d2f3d8c157781d4ae9d3f5a347690ae016f9d907fa9a7faa9"
    sha256 cellar: :any, arm64_sequoia:     "8f75db3ed61dd7d432fcbee5d3d726151cde09b18d62a8c84e4cc18698f4c0fb"
    sha256 cellar: :any, arm64_linux:       "e74886ace7be67306c0aebc62b5c80441a60f33e7c552922a670b6f9a61990a2"
    sha256 cellar: :any, x86_64_linux:      "9d995cbca556e9d885debe9d1aa70ed5c9402a1abe27f9d1009462bccab71eca"
  end

  deprecate! date: "2026-10-17", because: :deprecated_upstream

  disable! date: "2027-10-17", because: :deprecated_upstream

  depends_on "tcl-tk"

  uses_from_macos "sqlite" => :test

  on_macos do
    depends_on "libtommath"
  end

  # https://sqlite.org/draft/sqlanalyze.html

  def install
    system "./configure", "--with-tcl=#{formula_opt_lib("tcl-tk")}", *std_configure_args
    system "make", "sqlite3_analyzer"
    bin.install "sqlite3_analyzer"
  end

  test do
    dbpath = testpath/"school.sqlite"
    sqlpath = testpath/"school.sql"
    sqlpath.write <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    SQL
    system "sqlite3 #{dbpath} < #{sqlpath}"
    system bin/"sqlite3_analyzer", dbpath
  end
end
