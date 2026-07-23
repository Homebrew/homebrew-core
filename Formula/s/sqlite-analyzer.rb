class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2026/sqlite-src-3530300.zip"
  version "3.53.3"
  sha256 "bb80bf8a3bffc19241ce8aba5a4bc74e9c3980013cb0b5f0f0976a99516942af"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b56837f9676e748e8677b77f42218a1773036314028502b5fabdf8ec7239cb9b"
    sha256 cellar: :any, arm64_sequoia: "bd97962e421bcdc825ac54eef602e412d658777812f63990b6167c06328ccee3"
    sha256 cellar: :any, arm64_sonoma:  "5ba9647b9761e756838daba168d3205fd4de796e7b1b9c8eb606fcf8f3b67b8f"
    sha256 cellar: :any, sonoma:        "7f74ff7a209850a7e143797d7bc7e335ba5ac1b84bf16657559ec9558f1e4d5c"
    sha256 cellar: :any, arm64_linux:   "c1efe6fb313dab8682a7ca388f6c871e653911ad2f390c02073bc2d8e7354fca"
    sha256 cellar: :any, x86_64_linux:  "06c9153835e3e206419c100bc25f7daec5e3165698e3826f7ed0847608808b80"
  end

  depends_on "tcl-tk"
  uses_from_macos "sqlite" => :test

  on_macos do
    depends_on "libtommath"
  end

  def install
    system "./configure", "--with-tcl=#{formula_opt_lib("tcl-tk")}", *std_configure_args
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
