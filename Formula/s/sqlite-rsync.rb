class SqliteRsync < Formula
  desc "SQLite remote copy tool"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2025/sqlite-src-3510100.zip"
  version "3.51.1"
  sha256 "0f8e765ac8ea7c36cf8ea9bffdd5c103564f4a8a635f215f9f783b338a13d971"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256                               arm64_tahoe:   "9ce25c4de4bf26b8047d0ae7ef30ea2610a7626f90f70866f5cf35def87cb920"
    sha256                               arm64_sequoia: "dfd8e7e5e3842ea4468d2480978f27f104c02f61ad556b8d238c3e29d2d0abe9"
    sha256                               arm64_sonoma:  "6146726a37ad19622a2f1632664f0cc13cc2b0af773fe70159371cd644767d92"
    sha256 cellar: :any,                 tahoe:         "43da0b99c1c55b10ddec3d2566d7296b4ca7c0ea5eab869a36e6f8a6f4af60a4"
    sha256 cellar: :any,                 sequoia:       "f2843d5d04e201bbc7454a4d081b5fa411b2528f9108d8605a2a2c8c2a3c1d5a"
    sha256 cellar: :any,                 sonoma:        "bf598e9bc316b48059926bcab2940f6f91b361aacb972665c8304fa870822cb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebd91734b26f4faa997f794178b0b6a04e54ce8c6fb569a7cdff44ddc4f79fff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b788af7fe3c9d03b10a2ea68e4d4b85a7271599e01404211a07323fb38b0161b"
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
