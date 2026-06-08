class SqliteRsync < Formula
  desc "SQLite remote copy tool"
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
    sha256               arm64_tahoe:   "1c9752c3d49b2bba49db2ceb85ca57b5b98280dfadc509aeaf43b752b1f58acb"
    sha256               arm64_sequoia: "99cc429c2baf8b5631ed1124d0ce504de700932c72da161e2812742aa9a96f44"
    sha256               arm64_sonoma:  "6239ed45024a471e62b29458ce4aa56de7ed71dae77d51c21b45c1d91c2484c8"
    sha256 cellar: :any, tahoe:         "3b9fbcae9a4fb6e9f4db8a786e5f49781aa998b03c8444e1b6905090244a4ae2"
    sha256 cellar: :any, sequoia:       "a93988fb5811cc178ea3c80fc8379903a895f391c620f3a15aebae2eef1e6970"
    sha256 cellar: :any, sonoma:        "8a47818d4b855eb4fb9061908f00fe7f1f3bafbb5dc85c0acaae6be79f54f6f1"
    sha256 cellar: :any, arm64_linux:   "b40f8a075eb72b31360b5ca2c6e43b42f5dbed024c112baec0a8366936c8e9ad"
    sha256 cellar: :any, x86_64_linux:  "374d8c8f76390d44e1a33874d7e4407791287c4336c7aad863cae68bbfb6cd48"
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
