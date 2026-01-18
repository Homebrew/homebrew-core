class SqliteRsync < Formula
  desc "SQLite remote copy tool"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2026/sqlite-src-3510200.zip"
  version "3.51.2"
  sha256 "85110f762d5079414d99dd5d7917bc3ff7e05876e6ccbd13d8496a3817f20829"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256                               arm64_tahoe:   "fb5a262c2d0b25e42af75c29a75b7c45a0e698070222a2e9f7025917e1c8480d"
    sha256                               arm64_sequoia: "a6191096d172ea5b7af10a55b93a01346a9def258e64df4a07fcce3f1cfa5b9b"
    sha256                               arm64_sonoma:  "679f98f8b9d61b20771f70ade9f08ac62dbd3df20fb9b1dd02cb515cae8eb198"
    sha256 cellar: :any,                 tahoe:         "d3f04d82254099dc46da069e0f186f74def6a9376724f21a4b74949368ed2cc0"
    sha256 cellar: :any,                 sequoia:       "4c64665f0957803dd825183435be24e60451d8d029f6d443e548be59ba7e8c6f"
    sha256 cellar: :any,                 sonoma:        "392c0f1b51ff6326ebb5b9a01ecfe8842bbcccadf4637faa5bcd274795cf2b8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "878cdefc8fa47685d866404aa4bb0208f3573c8e7a0a1f96607e4164b0083535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11e4113cb62bdbe11f37bf2c6ebb02519258392e6981924aa4d56d3b201b90d7"
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    tcl = if OS.mac?
      MacOS.sdk_path/"System/Library/Frameworks/Tcl.framework"
    else
      Formula["tcl-tk"].opt_lib
    end

    system "./configure", "--disable-debug",
                          "--with-tcl=#{tcl}",
                          "--prefix=#{prefix}"
    system "make", "sqlite3_rsync"
    bin.install "sqlite3_rsync"
  end

  test do
    dbpath = testpath/"school.sqlite"
    copypath = testpath/"school.copy"
    sqlpath = testpath/"school.sql"
    sqlpath.write <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    SQL
    system "sqlite3 #{dbpath} < #{sqlpath}"
    cp dbpath, copypath

    addpath = testpath/"add.sql"
    addpath.write <<~SQL
      insert into students (name, age) values ('Frank', 15);
      insert into students (name, age) values ('Clare', 11);
    SQL
    system "sqlite3 #{dbpath} < #{addpath}"
    system bin/"sqlite3_rsync", dbpath, copypath
    assert_match "Clare", pipe_output("sqlite3 #{copypath}", "select name from students where age = 11")
  end
end
