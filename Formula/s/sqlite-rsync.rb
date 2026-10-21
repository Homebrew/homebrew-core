class SqliteRsync < Formula
  desc "SQLite remote copy tool"
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
    sha256               arm64_golden_gate: "ab5a91aa3f348951f3a228c71048aaa0633032a3b30c8319d6a06802657ca766"
    sha256               arm64_tahoe:       "fdfd5bf20e1d5ffaa1396c901072366e712b04bdf3c90a867a3f6f223809ff0b"
    sha256               arm64_sequoia:     "232359b75127e38b32a994b8c92990bbbedd4c3d38f038df9c9c6c19452d4e0c"
    sha256 cellar: :any, arm64_linux:       "566ea2e356b994dc60812d92d323ab93f05386a1966d9215da8ef46a2e77e6a6"
    sha256 cellar: :any, x86_64_linux:      "11aad8258f09503d664f1501549ab4ae312a3082567c26087d3838ce65d083d4"
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    tcl = if OS.mac?
      MacOS.sdk_path/"System/Library/Frameworks/Tcl.framework"
    else
      formula_opt_lib("tcl-tk")
    end

    system "./configure", "--disable-debug",
                          "--with-tcl=#{tcl}",
                          "--prefix=#{prefix}"
    system "make", "sqlite3_rsync"
    bin.install "sqlite3_rsync"
  end

  test do
    dbpath = testpath/"school.sqlite"
    copypath = testpath/"school.copy"
    sqlpath = testpath/"school.sql"
    sqlpath.write <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    SQL
    system "sqlite3 #{dbpath} < #{sqlpath}"
    cp dbpath, copypath

    addpath = testpath/"add.sql"
    addpath.write <<~SQL
      insert into students (name, age) values ('Frank', 15);
      insert into students (name, age) values ('Clare', 11);
    SQL
    system "sqlite3 #{dbpath} < #{addpath}"
    system bin/"sqlite3_rsync", dbpath, copypath
    assert_match "Clare", pipe_output("sqlite3 #{copypath}", "select name from students where age = 11")
  end
end
