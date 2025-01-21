class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2025/sqlite-src-3480000.zip"
  version "3.48.0"
  sha256 "2d7b032b6fdfe8c442aa809f850687a81d06381deecd7be3312601d28612e640"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "df2d1986ce154100d5d38f08e08119a4b685276d98b835a7b1e46471b9aa9c0a"
    sha256 cellar: :any,                 arm64_sonoma:  "155ab4533348b1df34738609278d67bf1dc83e4a694177586206d5ae74ff902a"
    sha256 cellar: :any,                 arm64_ventura: "5a17dde086d2c68eb01df851f6872b95dbcb016c5085ec90b2f413b7ee1fe7b6"
    sha256 cellar: :any,                 sonoma:        "80306524d5f0bb6ca2752f8f14a8f9df2ba98105194e9fd2497bd734feadeb2f"
    sha256 cellar: :any,                 ventura:       "f914be72c326ae7c54f4caabb2ce8a6e8014d37c6848b23f33d382f481d72bae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f8e2bb4be5498d3a1a7327e6329861509a5537a085f74a809d14154c36a4e33"
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
    sqlpath.write <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    SQL
    system "sqlite3 #{dbpath} < #{sqlpath}"
    system bin/"sqlite3_analyzer", dbpath
  end
end
