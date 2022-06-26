class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2022/sqlite-src-3380500.zip"
  version "3.38.5"
  sha256 "6503bb59e39ec8663083696940ec818cd5555196e6ca543d4029440cca7b00d9"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ac8603f04f097f5ff6b7166e61905f3e738fe464ab378887cb7b5b4a27ebaa9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e8059d2b6487f44a60002d0bc08aa5fa9e88d8d06c6e0b13c01512b6b7e32b0"
    sha256 cellar: :any_skip_relocation, monterey:       "f606a153ba9e5d388809695859fbd614323c840b636e642061f333e945f5fb43"
    sha256 cellar: :any_skip_relocation, big_sur:        "b797e6a93f854362afd4df9de702a716d91b334396bddb038c268abe7e1d9afd"
    sha256 cellar: :any_skip_relocation, catalina:       "134694b01c28845638389b9c4d07581a0d90ded9adc749b21baebd6a6c1fb358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a328a6a9c4d9744ed8989fbd1e0b1b268fded3f2b77a89589192335d1c918995"
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
