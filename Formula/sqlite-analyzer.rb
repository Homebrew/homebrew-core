class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2022/sqlite-src-3370200.zip"
  version "3.37.2"
  sha256 "486770b4d5f88b5bb0dba540dd6ee1763067d7539dfee18a7c66fe9bb03d16d9"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b05f22d01616b2e920fb824ec7bf01c1922cf043b0569de6e459dddb7d3ddf7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3136ba2c45c943840e18d1cf8781e38ad615271bf165c5ae978c72449930f05"
    sha256 cellar: :any_skip_relocation, monterey:       "3682dc83ccfeac9161682293b4d239bfc4b8ff7c10e6b080d3117bf3593671bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "e865d11a629d75632f2aeb5af792abf233d2874969db921e2f9baf66427cd50e"
    sha256 cellar: :any_skip_relocation, catalina:       "0a3f8294595def23f6b34c45509ec9ffd548f21a4e22ff136f3c4544770a9115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b46922469f5a4a2404c6f12468f22c0e90ad13bf7a18e548d7f9670b149656ab"
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
