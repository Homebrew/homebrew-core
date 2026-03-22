class SqliteRsync < Formula
  desc "SQLite remote copy tool"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2026/sqlite-src-3510300.zip"
  version "3.51.3"
  sha256 "f8a67a1f5b5cae7c6d42f0994ca7bf1a4a5858868c82adc9fc1340bed5eb8cd2"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256                               arm64_tahoe:   "c57a2ca27f068f2250eba95765cd85d9900c24f39b2d013a7b0e2b36f079d602"
    sha256                               arm64_sequoia: "3fa2b08eb9020585cfc5bb0a3ccd049b59760aa9837fcc1b4cdab8e49c22c512"
    sha256                               arm64_sonoma:  "814f07f546dce89b23700d2bb15ca22ab79bb9084d65657fdcba78970909afc3"
    sha256 cellar: :any,                 tahoe:         "22659b2584507871de33c5461b44bc73a9e12a719584e00aacc8ca9c7a097b3e"
    sha256 cellar: :any,                 sequoia:       "0a2737259d95f6522392e2435cc624995693d31b33a7be302addc0047b5986cc"
    sha256 cellar: :any,                 sonoma:        "ea1998cd7270b65ccadfebdef673658937b2a660eb0b54af6aa3b07d1b40fd76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7da897e4351e8f463f4e989c0e77c104bd7b18ebc31cdf524e355fb2e6709cdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98cd63f64373ad7a0df564bbd9b09ccbf9ba1abf718afff959eda9975833ea66"
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
