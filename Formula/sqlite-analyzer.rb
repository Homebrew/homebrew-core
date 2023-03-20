class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2023/sqlite-src-3410100.zip"
  version "3.41.1"
  sha256 "db929012f9009e7f07960e7f017e832d8789a29f4b203071b4fd79229e7d7a20"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "890baf96b89043f3e92349fe650d0f69019917aa0ac58143cac980ee38e7c920"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c371b69ece34f071ebef4eaa8deefd0699caedc6f0e53ab17a55de14fb6317d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c2c218ab6a0d771692f14408dc318c8fb6b74a8f116a33d1d9a090b9b839f4a"
    sha256 cellar: :any_skip_relocation, ventura:        "14c93aca45bc1b7b4b2c2994b2bc5c73ece8f315e1892a7275e8735c75b89e26"
    sha256 cellar: :any_skip_relocation, monterey:       "63b491a644694ab5bb024c65ed2797d2cb93f64ae2c03bc087f5c44df221d05b"
    sha256 cellar: :any_skip_relocation, big_sur:        "be2b1682aef23aafe81931377bcbb4c7819576a69ed62aa7ec8e599c45011ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bebd70e8a0bc28b60b13c6438ae2d51f99214d5dc5b68929517930e2d397af0"
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
