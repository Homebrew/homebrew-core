class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2026/sqlite-src-3510200.zip"
  version "3.51.2"
  sha256 "85110f762d5079414d99dd5d7917bc3ff7e05876e6ccbd13d8496a3817f20829"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c1961bd266c144285f35703f3e5fcb678f5cb30eaf51345d859e50e36bfde998"
    sha256 cellar: :any,                 arm64_sequoia: "f430a8de5bb07a2f6f2c01c35f9b03d63c5aaade23a5206df7803a074e3c986d"
    sha256 cellar: :any,                 arm64_sonoma:  "29778806e69788fb48880f98b2b26ddade0da3b4649ca77be143c17f9594f283"
    sha256 cellar: :any,                 sonoma:        "9a3b47f0a8ff07ba35e32a1a5bd947be494fe024a9826293505672ac87519106"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a312dea1a853e0e6a7a64abfc338194c4c73073c646e59939dfe42c32adca76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6d83419b804f025043ccabc72c8587fcd592e881cb793b16a753191bdbd33f1"
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
