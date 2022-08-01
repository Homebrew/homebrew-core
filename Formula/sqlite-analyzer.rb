class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2022/sqlite-src-3390200.zip"
  version "3.39.2"
  sha256 "e933d77000f45f3fbc8605f0050586a3013505a8de9b44032bd00ed72f1586f0"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6544833cfdb9cc9ee56202a522ae54d750175db8f1bbc4c0f86bb0c63e98c778"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90eb8125b2a327eb1b30dde5b9e1580fa6d348a8a9d6efa840363d39b01a9f08"
    sha256 cellar: :any_skip_relocation, monterey:       "401c21cb682751c67113438cef1a7321ac6063553548a5bbe7f156e747259692"
    sha256 cellar: :any_skip_relocation, big_sur:        "238fd11f3c8e0aa23929c33c34c6e7e4b7e425155cc5210adce19ae599389b35"
    sha256 cellar: :any_skip_relocation, catalina:       "567dbec9a05e51c89bb4f6ef0583f898152bcbc547796ed9d1fdc7b125fb50ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55272e5498a1c6233996608327196fafb67e0b91e262b7b662127ee9b45e7fd1"
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
