class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2025/sqlite-src-3490200.zip"
  version "3.49.2"
  sha256 "c3101978244669a43bc09f44fa21e47a4e25cdf440f1829e9eff176b9a477862"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f7e90f78db2a0025da80a686bcbb01c17fc8b431484f328c8f88d66b457b8b7c"
    sha256 cellar: :any,                 arm64_sonoma:  "7bdc35d3236c57f446b3ebbe58c7bf55f1ad711c0da0ae1ce07cbb836c0ca4da"
    sha256 cellar: :any,                 arm64_ventura: "e9e5c6d350669523acda14920728bace386c731cd473f1fb8f95af5ecd3065ee"
    sha256 cellar: :any,                 sonoma:        "4f2fb13b9d51a6f985574cada7882537cc5cd8a9953f61cc4717d41d8b1fc5e1"
    sha256 cellar: :any,                 ventura:       "3c5af2f67e1405c2e61fbb97b9c88a33d33f009dd54c21f42d1d68bf9fb87e43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ef51b37d8c80671fc13f132b8b28d07460aa41e3a74187ca6987af981964a3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6e818ebe8fa3521a71c173281e4c637ff4a632e0b230ab251cb72e1179c49d1"
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
