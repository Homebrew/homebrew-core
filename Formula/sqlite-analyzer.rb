class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2022/sqlite-src-3390400.zip"
  version "3.39.4"
  sha256 "02d96c6ccf811ab9b63919ef717f7e52a450c420e06bd129fb483cd70c3b3bba"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91e7656b001aa1b8bf9adb2c85829e7a383e21ce66145ad1ef0ebda2f624ba7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9895de6e8970a81032df286b331ed0b969a033c562759fb107eaa4214c5bbc1"
    sha256 cellar: :any_skip_relocation, monterey:       "56db04e939e541572ff6ed7a11979d36b35a71d5da4c915eff37fa8a8664213b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ac1ac6a026adb8ca89f8a2293268ca3a58f2be8448970b2281cb73a6bb06515"
    sha256 cellar: :any_skip_relocation, catalina:       "084920673733a786384a17b8c39f36b974a5e946c53bd7bf133785f577a151f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6587b049d088a4612ff25a672036fe305f1abeea6d20a37e53cae8a566d28c75"
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
