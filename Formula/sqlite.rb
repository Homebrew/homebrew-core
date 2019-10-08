class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/"
  url "https://sqlite.org/2019/sqlite-autoconf-3290000.tar.gz"
  version "3.29.0"
  sha256 "8e7c1e2950b5b04c5944a981cb31fffbf9d2ddda939d536838ebc854481afd5b"

  bottle do
    cellar :any
    sha256 "a7ca0667354f342c92cd0da87c80502327a79df859f951203d4e3f49dda4777d" => :catalina
    sha256 "5f2f8f36a8d13733b0374ac39bdcd32dea10315e7442b9bb9942465487cb7811" => :mojave
    sha256 "dcdc548263b6a8611d0e3532da5e216399cbd51e04277bb1ec9130fbb1125994" => :high_sierra
    sha256 "59e5e8d4abca99d7f3162bf8079be9efadebf459b6b24eaaa8d0effba8bb3fd7" => :sierra
  end

  keg_only :provided_by_macos, "macOS provides an older sqlite3"

  depends_on "readline"

  def install
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_COLUMN_METADATA=1"
    # Default value of MAX_VARIABLE_NUMBER is 999 which is too low for many
    # applications. Set to 250000 (Same value used in Debian and Ubuntu).
    ENV.append "CPPFLAGS", "-DSQLITE_MAX_VARIABLE_NUMBER=250000"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_RTREE=1"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_FTS3=1 -DSQLITE_ENABLE_FTS3_PARENTHESIS=1"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_JSON1=1"

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-dynamic-extensions
      --enable-readline
      --disable-editline
      --enable-session
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    path = testpath/"school.sql"
    path.write <<~EOS
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
      select name from students order by age asc;
    EOS

    names = shell_output("#{bin}/sqlite3 < #{path}").strip.split("\n")
    assert_equal %w[Sue Tim Bob], names
  end
end
