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
    sha256               arm64_golden_gate: "921f5366a6bbe064865bf5cc633d56aee3970a46f7eecafe78df6e1ab7385d63"
    sha256               arm64_tahoe:       "026e76fa93805b8954657f5ea1ee8acee6ec6e39f85c200b233d289d2a2297ea"
    sha256               arm64_sequoia:     "9e9f78834bc18690e6a28145d2281ca9f934bfe09c60d96a000369d5d509363b"
    sha256 cellar: :any, arm64_linux:       "61c02caac557d2cda35f1e12992b2efe826205eddbc1db58182e94941e3fcbc0"
    sha256 cellar: :any, x86_64_linux:      "f0ce9de70328ec3a8a5689cd1492b664b644109e6d2d4a7ed75a75ac3a32b8cb"
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
