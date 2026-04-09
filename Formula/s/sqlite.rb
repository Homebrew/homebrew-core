class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://sqlite.org/2026/sqlite-autoconf-3510300.tar.gz"
  version "3.51.3"
  sha256 "81f5be397049b0cae1b167f2225af7646fc0f82e4a9b3c48c9ea3a533e21d77a"
  license "blessing"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.tr("_", ".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "61b8c41bd50692618317c15cf49df150c43dc1171a0eb22e34398320675428f5"
    sha256 cellar: :any,                 arm64_sequoia: "76cc45e2468ed978994cebd09c86f5c88308f80a57f7744813b699b786451b3e"
    sha256 cellar: :any,                 arm64_sonoma:  "58cc3efa81a9415e21991191bed05e9af0ed07d836a4d1288eefb36fcbf6234f"
    sha256 cellar: :any,                 tahoe:         "bbb00a1972755629db38439a8f36592ae1282ae76cf7adc665d5923c99fa8d43"
    sha256 cellar: :any,                 sequoia:       "da75d72b08d32851919e68df4c0d772abc84dd7157a742759b04aaddee4d63b2"
    sha256 cellar: :any,                 sonoma:        "1804a10be21353ffdcab30daf39602df232a5ed73c50fced8d6904892edd8857"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a052cecdfab5101384518ea53bbe20287f00e18e280abb11fb79e63365a31d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1699f0f7d4bd0a724140bb1e46709c93e9882d60ebc630bc83cdb21f3fb47e69"
  end

  keg_only :provided_by_macos

  depends_on "readline"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Default value of MAX_VARIABLE_NUMBER is 999 which is too low for many
    # applications. Set to 250000 (Same value used in Debian and Ubuntu).
    ENV.append "CPPFLAGS", %w[
      -DSQLITE_ENABLE_API_ARMOR=1
      -DSQLITE_ENABLE_COLUMN_METADATA=1
      -DSQLITE_ENABLE_DBSTAT_VTAB=1
      -DSQLITE_ENABLE_FTS3=1
      -DSQLITE_ENABLE_FTS3_PARENTHESIS=1
      -DSQLITE_ENABLE_FTS5=1
      -DSQLITE_ENABLE_GEOPOLY=1
      -DSQLITE_ENABLE_JSON1=1
      -DSQLITE_ENABLE_MEMORY_MANAGEMENT=1
      -DSQLITE_ENABLE_RTREE=1
      -DSQLITE_ENABLE_STAT4=1
      -DSQLITE_ENABLE_UNLOCK_NOTIFY=1
      -DSQLITE_MAX_VARIABLE_NUMBER=250000
      -DSQLITE_USE_URI=1
    ].join(" ")

    args = [
      "--enable-readline",
      "--disable-editline",
      "--enable-session",
      "--with-readline-cflags=-I#{Formula["readline"].opt_include}",
      "--with-readline-ldflags=-L#{Formula["readline"].opt_lib} -lreadline",
    ]
    args << "--soname=legacy" if OS.linux?

    system "./configure", *args, *std_configure_args
    system "make", "install"

    # Avoid rebuilds of dependants that hardcode this path.
    inreplace lib/"pkgconfig/sqlite3.pc", prefix, opt_prefix
  end

  test do
    path = testpath/"school.sql"
    path.write <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
      select name from students order by age asc;
    SQL

    names = shell_output("#{bin}/sqlite3 < #{path}").strip.split("\n")
    assert_equal %w[Sue Tim Bob], names
  end
end
