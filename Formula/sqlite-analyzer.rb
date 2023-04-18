class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2023/sqlite-src-3410200.zip"
  version "3.41.2"
  sha256 "87191fcecb8b707d9a10edb13607686317d7169c080b9bdc5d39d06358376ccc"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6159465c7f61923c80e7266f8fac39b4a7ad7107e346bc160a217a77ec1b770c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a7f560573f76f11c379248c1f2b5edc8819dc4bea3c2efa04c63de1c0764f94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65106a6e17d23cbe846247397a55330581d50ecb17a84d90a22e08107b88ed36"
    sha256 cellar: :any_skip_relocation, ventura:        "f3803a89caace833e9d3cd859e2ed016c6f333fecfee23fe6b54f6b00e5ea33d"
    sha256 cellar: :any_skip_relocation, monterey:       "d6993530f7e6b207f608f85e25ead405d40d09c13abdfc9d88443dc6c57c532f"
    sha256 cellar: :any_skip_relocation, big_sur:        "072884d2b00663416b85f5fca30af25428a99a57f414063af4497980e6e0f1c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7db323ff438adef8a2e9ab75e6a123952b14e4b37d47ab51db36bc51aabf9444"
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
