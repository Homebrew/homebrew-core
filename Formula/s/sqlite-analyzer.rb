class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
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
    sha256 cellar: :any,                 arm64_tahoe:   "47ba7ae3b965af371df60ca1983ec977eea991ca623d286e0e35bad6195e67d8"
    sha256 cellar: :any,                 arm64_sequoia: "8a3b2ad75ac91a99d07afac6e6223b515dae73efa16e70c8720ff1c3e5ae3b79"
    sha256 cellar: :any,                 arm64_sonoma:  "9f95fe480a57131dcf127ded6a718c8e79a257a80348131875c6388b14a03742"
    sha256 cellar: :any,                 sonoma:        "fa3fd0e9f8c5abbdf1542723d1e1520b89b7cd9b5584330269ae639fbb9fc1df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66eb695dced8b9b31a6387b3e2ea9b5768b54869510d499c0bb2e2bafae51ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1f3a46ecba766cd5db581e97ad9623617e54209fc97700212e596bcaf8eeea7"
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
