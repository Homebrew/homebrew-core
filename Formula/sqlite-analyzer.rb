class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2021/sqlite-src-3360000.zip"
  version "3.36.0"
  sha256 "25a3b9d08066b3a9003f06a96b2a8d1348994c29cc912535401154501d875324"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e78e1c2c8eb006ec96b3ca1865e3dc79ea29a0e557c5eb55316903fa0c6dd352"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "279951170e98f9f3b4b23fbd34cd210c6a3ad3c8b564f7a6dd41366f98610cf9"
    sha256 cellar: :any_skip_relocation, monterey:       "80e4e43e9de899dcd29baef59790315135305788439e1abad77e7871816954f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e912eaec069e12f498c2ba3bc09217cd2cf924ff8e26bfa966680b98d53f95c"
    sha256 cellar: :any_skip_relocation, catalina:       "927cb8b16c0c5c4fefc9169c1d51346c6db3daaba27219a194b353d0e1a4b08f"
    sha256 cellar: :any_skip_relocation, mojave:         "039205cb4d999259011589f99db4dea8612a0a743cca17265c06734342820489"
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
