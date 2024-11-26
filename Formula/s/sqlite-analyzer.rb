class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2024/sqlite-src-3470100.zip"
  version "3.47.1"
  sha256 "572457f02b03fea226a6cde5aafd55a0a6737786bcb29e3b85bfb21918b52ce7"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d393093847c9a83840637ecddfd9296bd0bf69881df2865b7fbd3727ecc4fd77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d42650a6dcfa6d82cfebee6ff9fc89f12f901a537265bf10125beae126e3fbc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ec667bb1cc7c296a56026ce30271411d45adf46c2ec3650a14c182ce73beb6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccdf367baedb023188b51cea27e6fbd14f0b0368d6b0afd31570ab9e4a6f5f40"
    sha256 cellar: :any_skip_relocation, ventura:       "cbbf9ec978b6c77f188d6c7c7a9699ada755381ee53ce71d6d6fc870abf7d3f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31f9d8af5949cda373637a98af57ede8558e6dd103f20545792a7349150a97e9"
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
