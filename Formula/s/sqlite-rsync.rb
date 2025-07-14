class SqliteRsync < Formula
  desc "SQLite remote copy tool"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2025/sqlite-src-3500200.zip"
  version "3.50.2"
  sha256 "091eeec3ae2ccb91aac21d0e9a4a58944fb2cb112fa67bffc3e08c2eca2d85c8"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256                               arm64_sequoia: "113ee7bfdfee0cb6fb3f96c2ad1651907eaea39901c0f81534d3d8c65f021a4b"
    sha256                               arm64_sonoma:  "fd0f2eb738ee8be586d8b2db3a8b6543f49e4e8b89a37b4822b598dbc7df360f"
    sha256                               arm64_ventura: "8c35cd3ebace3ea3645e7a364d132ba93a61f14aee90e0a307886e53c2287161"
    sha256 cellar: :any,                 sequoia:       "4bf5c931d092aa3e3478b761557eb52e3112fd188295c16220a96a9a2f653bbb"
    sha256 cellar: :any,                 sonoma:        "cb2bb28f19497ac2d015b5a25e71de8b3d03a73107c0cff8d4de55553905af2f"
    sha256 cellar: :any,                 ventura:       "23a21505ba3b98cb14895d52a74a475502effc85add8697922453a1738e2fb06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38fa817e1e57088b22f62150da8ae0ac8dd93246220681ea4f052f100dcb24f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0200714a2f9efea8ade0198adcd61cb6cae7b70d251368bd3d63f49804514f0"
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
