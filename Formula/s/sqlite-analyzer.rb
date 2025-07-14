class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2025/sqlite-src-3500200.zip"
  version "3.50.2"
  sha256 "091eeec3ae2ccb91aac21d0e9a4a58944fb2cb112fa67bffc3e08c2eca2d85c8"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "08602ca5a37e69ba8ce9903890e4c511dc9e9163b9f5b836392c5e369b272f6e"
    sha256 cellar: :any,                 arm64_sonoma:  "1512826a6929d494d2018a0d93f6d0b7ce68d89578ffff7e5de228693766f27e"
    sha256 cellar: :any,                 arm64_ventura: "73bfaad01ecb2b0373e588027977c82147499da25172eff47125e1920d1856a5"
    sha256 cellar: :any,                 sequoia:       "2b944b2cade844fe718a221418feae862461e23f77d177925555cbeff32722af"
    sha256 cellar: :any,                 sonoma:        "99dab955d4eb84b1c3f037854539c582c0004bb7e237b1585a2ad4cddfc2b346"
    sha256 cellar: :any,                 ventura:       "e6c58c34d17746710eb8348c6b16125b54640df5f57fa199e41ab41d47b2e4d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10424e992941c7bb9f369e8bcc2a33fed99dac5c8bed1a23d05f276e0b79bd2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1a46673cffffcd3d5427d0b7059380da95f232afcd2a74047008177072afcd7"
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
