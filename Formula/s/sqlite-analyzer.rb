class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
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
    sha256 cellar: :any,                 arm64_tahoe:   "8be3ab5586e8ff6267667150bfa5c27cb6aad6dc46d8329de109a5240c3e8320"
    sha256 cellar: :any,                 arm64_sequoia: "6214c582f38f6150f3c0144c259e1bf2f59cacce68966ed19926297427cfc316"
    sha256 cellar: :any,                 arm64_sonoma:  "11b155a9ec565d212a9746ccf0681632393371976c16922c080672aa686dbf4e"
    sha256 cellar: :any,                 sonoma:        "8fa72d0001cc16bf3f4b18358a4323f082e10aa9340de204927742b770107bc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8625175e97d987742a204d589c380d1b032ef7f4950f97a388dac5863f80b7ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0006e2cb1cbb1beb9d178900194038144819f03867c27252b51f5a152e4a3ea7"
  end

  depends_on "tcl-tk"
  uses_from_macos "sqlite" => :test

  on_macos do
    depends_on "libtommath"
  end

  def install
    system "./configure", "--with-tcl=#{Formula["tcl-tk"].opt_lib}", *std_configure_args
    system "make", "sqlite3_analyzer"
    bin.install "sqlite3_analyzer"
  end

  test do
    dbpath = testpath/"school.sqlite"
    sqlpath = testpath/"school.sql"
    sqlpath.write <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    SQL
    system "sqlite3 #{dbpath} < #{sqlpath}"
    system bin/"sqlite3_analyzer", dbpath
  end
end
