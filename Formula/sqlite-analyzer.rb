class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2022/sqlite-src-3390100.zip"
  version "3.39.1"
  sha256 "366c7abbee5dbe8882cd7578a61a6ed3f5d08c5f6de3535a0003125b4646cc57"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7fea209d7b1e3d626e2206838641c404eaf5645adb14e8dadbce0ced0a9ffb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "670c6e316ff7d128e25e30f3b0060df2e6efb257cad62d6943f11f8f611f09fb"
    sha256 cellar: :any_skip_relocation, monterey:       "7ce2e29e85faf28fdaea8c024bb9cde3e146ddb912a094dfdfe2acdc98cf320a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b0910c90165d70f99dd0c22664aa098a0c5117e7e1504d02cc9e73fa50eb161"
    sha256 cellar: :any_skip_relocation, catalina:       "b49e3619cfe3faa4ac800d080ca0a04309a5e5161fbe9e5ce1109ff894f561b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcb2f3e5b52f36d147fca278c8e2d26895386e2237b93905d860c474cac35b9b"
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
