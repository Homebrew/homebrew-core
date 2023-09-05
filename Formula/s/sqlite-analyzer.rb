class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2023/sqlite-src-3430000.zip"
  version "3.43.0"
  sha256 "976c31a5a49957a7a8b11ab0407af06b1923d01b76413c9cf1c9f7fc61a3501c"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aba4c3bb5bc69f124786aae06d50fafe349fcf773f9b93c985ff5f880a0992dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5da62f4434846b8cb7e81b7e79df80e857e62f48b4e87c84e9bfb31b04f097ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a77e14a1cdf81b176f4b88b426e4d914b31fd6ff9a34b0a8060bf6ef08a7973f"
    sha256 cellar: :any_skip_relocation, ventura:        "3231adbda0b2a5452231e800e30e05b435ab0fa38fd879e17e7424b9df0df573"
    sha256 cellar: :any_skip_relocation, monterey:       "7da3e233dec55f85b6a84b45a8b2659015949744c6bdb659ac7ac86ed783d3fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "f34420462de37ef0b71c27221255a398e510ac71cacabb00334fa76dcef136ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "105e8a54c68dcc072fe4a0d4d7264ac886b8df525a82549cf24018b18700876d"
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
