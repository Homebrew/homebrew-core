class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2021/sqlite-src-3350400.zip"
  version "3.35.4"
  sha256 "77007915a87ccc8a653d5f3d2d3a3cca89807641965c2a6e2958bea964ea02a4"
  license "blessing"

  livecheck do
    url "https://sqlite.org/news.html"
    regex(%r{v?(\d+(?:\.\d+)+)</h3>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "83aec45fa8fc0e93016bc9448ced3e3df5cde9c50a8c2182139a33c0841d0288"
    sha256 cellar: :any_skip_relocation, big_sur:       "9179d9837d8fb46777f716a6c6c56dd900bfd0ed84d530a030f24d197ac67204"
    sha256 cellar: :any_skip_relocation, catalina:      "15117fbba7169feee9f0ec8b0ac813ebb7b9e9ccdc678b705c901874330fce14"
    sha256 cellar: :any_skip_relocation, mojave:        "ed86244c5844bd978f4f243efad83ac21caf469f5450e98913d68b523987c2dc"
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
