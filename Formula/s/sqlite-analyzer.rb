class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2026/sqlite-src-3530200.zip"
  version "3.53.2"
  sha256 "cafff764c03f6d720968f746e2f47a986bbf12bf4c18904f1eb131c0b0b592d3"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c47d5ada155570b86607cef0a344f79aac2de3e6b00fa8a23c384b13ad77f7fd"
    sha256 cellar: :any, arm64_sequoia: "163bfd7f55e8cc3148236552fc824a2ccf42cc6ddf11e89dfc17965dea80bdf2"
    sha256 cellar: :any, arm64_sonoma:  "6719d8027f96af651c0cd97cd2d2b97a0e347459efe04d0a2c99efdcb99ad657"
    sha256 cellar: :any, sonoma:        "2d4a16b08f75ce79333f9879566a791641e7e55cb48ac8e6c6d5359414f0f7aa"
    sha256 cellar: :any, arm64_linux:   "a5806abee637eb3b39f8807a742f471591396e9ebfba9e7bac2665d8ac1b0f30"
    sha256 cellar: :any, x86_64_linux:  "44e9997597eb4f4b75d85400b4370b1808203a3b0b094be458f07445570869b7"
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
