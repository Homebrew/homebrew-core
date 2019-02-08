class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/"
  url "https://sqlite.org/2019/sqlite-autoconf-3270100.tar.gz"
  version "3.27.1"
  sha256 "54a92b8ff73ff6181f89b9b0c08949119b99e8cccef93dbef90e852a8b10f4f8"

  bottle do
    cellar :any
    rebuild 1
    sha256 "816f6edb6484d8debb47aa1ed780119ce43776991c972553bfbe722542a5993b" => :mojave
    sha256 "67933444aa339dac87f197188c868914e8302b35c6e0ba2584e2e36ee9ba4f56" => :high_sierra
    sha256 "309664c5f5fc9f1ab41284f2e9fa7355bd87bd8c691e8e9bd771bf1d0314a35d" => :sierra
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
