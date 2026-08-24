class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2026/sqlite-src-3530400.zip"
  version "3.53.4"
  sha256 "d18fa15aec74d8c17e1463f861095adc01b5ad190256acb4f91d22f0368d232b"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e0001cafaca5b5ab9d4e209d81e103ef7a872e4f66912d6d13a094a7737ac5d8"
    sha256 cellar: :any, arm64_sequoia: "74f7f55896ccdcca311ff43ab4198131384e3d71bd2dca155fba2287663194f4"
    sha256 cellar: :any, arm64_sonoma:  "87b92e63a163c3ce7840c01c0f6e73bc36eb4a5a606b5a9e418f7c716f6d0af6"
    sha256 cellar: :any, sonoma:        "397866508a17acfe31147353629863b7ada1107d5e264f4d8a22b6b0c78b7690"
    sha256 cellar: :any, arm64_linux:   "5bc48810c7bcdef96f13fdd79663191b192ae50deb9ce8659404c3638684904f"
    sha256 cellar: :any, x86_64_linux:  "a145efe6aa3120502d1214e36ba98b4307d0ef49a28f37310d47529d02f0921c"
  end

  depends_on "tcl-tk"
  uses_from_macos "sqlite" => :test

  on_macos do
    depends_on "libtommath"
  end

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
