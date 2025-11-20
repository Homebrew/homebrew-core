class SqliteRsync < Formula
  desc "SQLite remote copy tool"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2025/sqlite-src-3510000.zip"
  version "3.51.0"
  sha256 "5330719b8b80bf563991ff7a373052943f5357aae76cd1f3367eab845d3a75b7"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256                               arm64_tahoe:   "dd43d9d738991e0b8db97af24dd2cd8623cbc0e6987a1f0204c355c0bfed3d42"
    sha256                               arm64_sequoia: "4e2a9f1fea2a2b03076087f0ced35f591ec93cdb7c906b580ecf5704f122e5d1"
    sha256                               arm64_sonoma:  "ea4ed77e9193a63cba7d3fbb40eb9f99534ed72e1c71bcc70c4905aa5215f408"
    sha256 cellar: :any,                 tahoe:         "8582ae220f522fbd0889b27460bf801f2340307f8e7cfb5a99a9b3d201905cb7"
    sha256 cellar: :any,                 sequoia:       "4fcbf1c75e15ee13c7effefe08635f8511c630954801308a60975be536b26f77"
    sha256 cellar: :any,                 sonoma:        "7f10a664b31d6b7e5b97711e5f00a85a1ce824e63f4c44474939b0fbf3a6067f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff02d1dc03a08227a98654b33cb7f63137acff8c4dc6b1715d220e5e8ea38bb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b4c32dcb82b0a9a808e40cfda16bd494f8ffc0d7c23384aa0b6577312206c12"
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
