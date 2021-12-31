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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29364e244d788411686ee37506dd78203b78427b7174336a17bee7c443399f00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e271dd370a114ec628cd33c59d77f84bbade320d203f3844170008ec0e90d3be"
    sha256 cellar: :any_skip_relocation, monterey:       "22f11f2929aae2189c0745d2479f2d22886c21ba1b40d6a623654883b00f34fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "312e36ce70eaeda6c1f91549278ed0eefcacc1f73ec354ee5694d90a8c3263b0"
    sha256 cellar: :any_skip_relocation, catalina:       "4f1cbfaa4da2437bace58bbfe34134a61761a926a6a795510a1b02515f45a0de"
  end

  def install
    sdkprefix = MacOS.sdk_path_if_needed
    system "./configure", "--disable-debug",
                          "--with-tcl=#{sdkprefix}/System/Library/Frameworks/Tcl.framework/",
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
    system "/usr/bin/sqlite3 #{dbpath} < #{sqlpath}"
    system bin/"sqlite3_analyzer", dbpath
  end
end
