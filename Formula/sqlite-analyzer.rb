class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2021/sqlite-src-3370100.zip"
  version "3.37.1"
  sha256 "7168153862562d7ac619a286368bd61a04ef3e5736307eac63cadbb85ec8bb12"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33d6e3527ccf4ef9d2a0f58f47952293125d18d5b94830cc488ce33eddcb2fe4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e0fdaef71d3f0a605249145ac03f5d6b5372cc019e225956e652bc7f8df9b13"
    sha256 cellar: :any_skip_relocation, monterey:       "823769e2a778e9b36c7714859874a261e295f701354a7ed1f56773d274b6334e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e79007af69d9f5cbb831ee410d10daae21875d75a2e15a93d241a18108566c9b"
    sha256 cellar: :any_skip_relocation, catalina:       "a6052e4c2c43c900d8cd541ccf21495c4e82ab1f3b952c16aca584d82570c69a"
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
