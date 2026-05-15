class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2026/sqlite-src-3530100.zip"
  version "3.53.1"
  sha256 "1b2b5755d9064c4d5d1b0bf5307b48b089963e291c40cc7351318aa1b61c460e"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "74aa072d1a35f60b53e26619f24cb0790ecd045f808d925ac37f18f3292f4c67"
    sha256 cellar: :any,                 arm64_sequoia: "5c6578e87fa88736307c1dea7dc49a3f1d4901fa2988b3143487c7ee4f26617e"
    sha256 cellar: :any,                 arm64_sonoma:  "571b9bb455e52169cc92974206092fcc41fe8e993c4c04a38c43679f2d4d72c7"
    sha256 cellar: :any,                 sonoma:        "09309e8a108c9e174e7b3577576623ffb1bd3fd0033a7addbf2ec945abe61984"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8edf2f57a84f310357b1b2a7036763e2f27c698a21b434721248af565e6ef9d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f9bb67b9b38360554e3485b6ea482b58c2195a6a0a69ce2393b512b62b8ccf9"
  end

  depends_on "tcl-tk"
  uses_from_macos "sqlite" => :test

  on_macos do
    depends_on "libtommath"
  end

  def install
    system "./configure", "--with-tcl=#{Formula["tcl-tk"].opt_lib}", *std_configure_args
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
