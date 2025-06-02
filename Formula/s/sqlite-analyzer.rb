class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2025/sqlite-src-3500000.zip"
  version "3.50.0"
  sha256 "af673f28f69b572b49bb1558c4f191fd66e31acb949468ad2b01b2b6ed8043a2"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "559da968b936660e31408e76000d4a15152b44f1773974ec667ddb896192e97a"
    sha256 cellar: :any,                 arm64_sonoma:  "0b0282a7c8747caffcf87fcad405efc2b97c4175ade2e05fc826e841a2989c9b"
    sha256 cellar: :any,                 arm64_ventura: "1f9403054cd726dd14fdcc9af7df929b823dcdc9044ead2152b96485e75c5a7d"
    sha256 cellar: :any,                 sequoia:       "0f467f4751400ac070c3c5ea8766143062fae83cc7c6fb896994e2f1dcabdcd1"
    sha256 cellar: :any,                 sonoma:        "65517fbb625211717792bb0fe0c0e07fbaddbcbc99527596cc0222f055fec116"
    sha256 cellar: :any,                 ventura:       "29eb3089b5bf18adeea747032bf7139d82ef83bab051ac8c47fb563f5e62d206"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc05d42209dee8361c8e931f555bbd93955f66c4883bee67157760926ed4e20e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2b6f074b0ebdd2572d758337c6006defd1272bb2f3082f419791d0f731c8508"
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
