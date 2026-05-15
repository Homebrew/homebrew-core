class SqliteRsync < Formula
  desc "SQLite remote copy tool"
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
    sha256                               arm64_tahoe:   "78b35d4058d0922b7bbf7e4372e470758da01aa38c3ee7b37b1bf2345464317a"
    sha256                               arm64_sequoia: "9843a5d7b946d26f892db0e9c904b08f04644af2e193fac5110d12464b598280"
    sha256                               arm64_sonoma:  "a39e3b3b3fb78fa6d7da302ceb0bd0f42571517260807af36eb3c110f3140f25"
    sha256 cellar: :any,                 tahoe:         "aa3eda6725436b49781fe913de6b1e8bed04808192833796cbc630f7ad8374c3"
    sha256 cellar: :any,                 sequoia:       "007e1a03092d307b4684c396381c0cf415ba265047463f2c9e2055bd63ca7616"
    sha256 cellar: :any,                 sonoma:        "25d8e6b252541b73641e506221adc733831f0be6adc76523c4f41e357204e45f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd250fdb687441a6d485ff6542e3507de21c492ebbe254b1e120d4507d550627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0be7f580cc58002a672b19b34c8c45deb1051695f914c352339c9dd6355dd07e"
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
