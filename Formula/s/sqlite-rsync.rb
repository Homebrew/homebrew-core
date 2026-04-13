class SqliteRsync < Formula
  desc "SQLite remote copy tool"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2026/sqlite-src-3530000.zip"
  version "3.53.0"
  sha256 "fbc30cdbfcfa42c78fe7bddd3fd37ab8995369a31d39097a5d0633296c0b6e65"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256                               arm64_tahoe:   "dd57e0d4f217c9591aa46a7b1dade41b52bdd003f0368aed68c8f27528d64740"
    sha256                               arm64_sequoia: "cc836f4d2ff170c7d1ab1cfe2e95c57d135b322c020b5775c6be3b1b998fcd87"
    sha256                               arm64_sonoma:  "b018dc62ff3d4ce979f8d6fcbf6ee6047b7f9693df11ba0c93d2cddf5b090dc8"
    sha256 cellar: :any,                 tahoe:         "c21936858e183322311a639acee743e55745252fe59ecdad4a4385fe69781555"
    sha256 cellar: :any,                 sequoia:       "aeaef50ab7725e90c0e11abff8cb68fa575272745448ca10367352489eebefa0"
    sha256 cellar: :any,                 sonoma:        "636507607fc77dec0ee46eac35d7fb97063f26d7c1562fca92af6be061a93ec5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c144474481c22229f43c10400a9a724feb42f4c0d550c5c73d9a5d6303540356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "426b0448c8d2fe913a22c2a270b9b34a4c3182395133bab66d01f1fd88a23b3b"
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    tcl = if OS.mac?
      MacOS.sdk_path/"System/Library/Frameworks/Tcl.framework"
    else
      Formula["tcl-tk"].opt_lib
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
