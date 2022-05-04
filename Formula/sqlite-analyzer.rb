class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2022/sqlite-src-3380400.zip"
  version "3.38.4"
  sha256 "ca85ecd10a3970a5f91c032082243081a0aaddc52e6a7f3214f481c69e3039d0"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "522d52dac70b9962cfbf84463ecc7ecfb69feee5f13da1cb98b2bd10f7c9d36e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b67c43f6b8ed21f89a0e528f6b77689a2c5cd2150d76b81f011737a0ceff92c6"
    sha256 cellar: :any_skip_relocation, monterey:       "be1404594754f818c00132140d51352207f3302075f2b5215ad69f5ff3417709"
    sha256 cellar: :any_skip_relocation, big_sur:        "be3ceb050fad517b7ef4d2d5bf3c9e658934d71992bfc3d8fc0ef15a8d9edd9c"
    sha256 cellar: :any_skip_relocation, catalina:       "9bdcde55358b7baf780a4417684fc8fd28968ffe984c1a46fbe22a5943deb486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94312b31da55ff31924df8a437448a29ce7d73dfa455693acd992b0515bbb4a0"
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
