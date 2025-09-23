class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2025/sqlite-autoconf-3500400.tar.gz"
  version "3.50.4"
  sha256 "a3db587a1b92ee5ddac2f66b3edb41b26f9c867275782d46c3a088977d6a5b18"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.tr("_", ".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "5ec50891c34da3548d8be5df03001dfc9aaa275e759c7dbae1a407f5093b2513"
    sha256 cellar: :any,                 arm64_sequoia: "cafdb368572f534b9a2c016df82bb29733028c86b4bea062c1e927e7073f1dd4"
    sha256 cellar: :any,                 arm64_sonoma:  "0dba472359a4e91e82ecf4a2029d8a38966aed6ff7a4d027182d7bfba74e354d"
    sha256 cellar: :any,                 arm64_ventura: "0a2400a611fd89e1711699b3aa706ef0c5e8b4b01935615f1576498db536d31d"
    sha256 cellar: :any,                 tahoe:         "742a8cfa3880905e56cff0e9b7990b7d87c60b9883046699a1e84d2f0bba088c"
    sha256 cellar: :any,                 sequoia:       "9f333064c9e3a56f4325f4b9a12ff88d962ebb2783a5b622a2d2983c4879e74e"
    sha256 cellar: :any,                 sonoma:        "11c9d9c10fe7b502be00c8a85667367adb6718df93d2d2ba68a75405e41615e4"
    sha256 cellar: :any,                 ventura:       "d90906e7f13944a33f60a2955a13c40c092e5ec6b2cb3bc420a31ccdc656a08b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb06505e1827bb70598605f9195502552cfeb01942cf1859074a8308e84501ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55d0b499940a253d7fc05121bd73d602614712db9feac0623a67aa5b612f651c"
  end

  keg_only :provided_by_macos

  depends_on "readline"

  uses_from_macos "zlib"

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
