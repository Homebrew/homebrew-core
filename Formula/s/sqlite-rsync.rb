class SqliteRsync < Formula
  desc "SQLite remote copy tool"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2026/sqlite-src-3530300.zip"
  version "3.53.3"
  sha256 "bb80bf8a3bffc19241ce8aba5a4bc74e9c3980013cb0b5f0f0976a99516942af"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256               arm64_tahoe:   "32a76486d31530145c5321f49c07a7d8f5a147a88976941a2ac9fe0c56986d11"
    sha256               arm64_sequoia: "d9f2260d0f42fb482a330246129e98a10361dad8a85f2932a2199e2ffbbcd041"
    sha256               arm64_sonoma:  "ef4bfdba4a7b88ba2d64a08936ae98ab34b367ceb507bc042ddf24ce5187fc6c"
    sha256 cellar: :any, tahoe:         "5a2ac24bae57b7fb45f95c5b62557282a6a23d7ac21daa8a93a80f9902ca064c"
    sha256 cellar: :any, sequoia:       "24aeed4dfc7dda417ad8dfbf8b99553b3c61c6836984dee114e836a7a9ceb57b"
    sha256 cellar: :any, sonoma:        "789bd6b63ee8399421c520bd81adfc476c30424941fee531537dadae58e2f923"
    sha256 cellar: :any, arm64_linux:   "efc989f8e20751259dcd8c4b09fb744f57d65f9639ff21bde3e085fb4e072b7f"
    sha256 cellar: :any, x86_64_linux:  "f1198a9142acc272799f6c78d8622ceab9159ea358b71ee097146b2fb84a657f"
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
