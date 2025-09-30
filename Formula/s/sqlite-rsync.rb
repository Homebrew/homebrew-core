class SqliteRsync < Formula
  desc "SQLite remote copy tool"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2025/sqlite-src-3500400.zip"
  version "3.50.4"
  sha256 "b7b4dc060f36053902fb65b344bbbed592e64b2291a26ac06fe77eec097850e9"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256                               arm64_tahoe:   "07601d7947f50e9dec6a307708fd738c92cf87ffbc58e5dc9c1a4049c52ed5a8"
    sha256                               arm64_sequoia: "c982eb92c75c960d4768e1dd031d5f2dd8411cff373370f79af4d581b07d0b29"
    sha256                               arm64_sonoma:  "f8c12b60d263d80fcc8fc75c3e04ca858ac76b4364b7ec9cf92e12dafa08f02c"
    sha256                               arm64_ventura: "cb8a1fb0ecd2eb2bfdf3510e5f46f45dd0ae1ce9e9c3dc6260f89ee777d7a5a5"
    sha256 cellar: :any,                 tahoe:         "18b262c2eaf268513f7088d232f2d885f7dec150aeb6f54da299b417afdadd66"
    sha256 cellar: :any,                 sequoia:       "26e635dac9985870308ec1e0229f71b269bccb5e85d457918297213bc8aa31b2"
    sha256 cellar: :any,                 sonoma:        "7716d51a21c356552441ee4bd60cc4adb6c607edb3031c97a944599343dd1e8b"
    sha256 cellar: :any,                 ventura:       "c0a24205f5a2d676fc5fa4d01f5bf3129d6b8261ca41aefc3d50a63f640dabc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1ddaae16429ab92346b2bb9083411d58e2bf1559c79ae896f323d6f4091f5fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d87f7fb27d20982e09c67065f174545d5b3b67be9bd0ad5984f4250a037fdf2"
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
