class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2022/sqlite-src-3380200.zip"
  version "3.38.2"
  sha256 "c7c0f070a338c92eb08805905c05f254fa46d1c4dda3548a02474f6fb567329a"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acba5625d04e992a5bb36f850220006436b9e88704255b57b19c6b8f7697a7c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd6df08e559393a6fd181e9f6eada9e02237ef9ba869dfacb2c544ead889dfe7"
    sha256 cellar: :any_skip_relocation, monterey:       "c0ecf1e490ec4ed2259b0686270985b7d9a3d1a8d7c2baf2902391b429557cd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "acd2377f9f334c85691309b49045021b97d95796ce03984f099da73bf69919d5"
    sha256 cellar: :any_skip_relocation, catalina:       "a92ab2996e51f95b3dc087cde8b1df3ed861a75ebe21c6d96d6a1b141a80bc80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1c10ad0aa419e31fb427f06fed118346a8b19f928ac1f11f4970d9f7451597d"
  end

  uses_from_macos "sqlite" => :test
  uses_from_macos "tcl-tk"

  def install
    tcl = if OS.mac?
      MacOS.sdk_path/"System/Library/Frameworks/Tcl.framework"
    else
      Formula["tcl-tk"].opt_lib
    end

    system "./configure", "--disable-debug",
                          "--with-tcl=#{tcl}",
                          "--prefix=#{prefix}"
    system "make", "sqlite3_analyzer"
    bin.install "sqlite3_analyzer"
  end

  test do
    dbpath = testpath/"school.sqlite"
    sqlpath = testpath/"school.sql"
    sqlpath.write <<~EOS
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    EOS
    system "sqlite3 #{dbpath} < #{sqlpath}"
    system bin/"sqlite3_analyzer", dbpath
  end
end
