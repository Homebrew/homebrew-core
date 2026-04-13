class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://sqlite.org/2026/sqlite-autoconf-3530000.tar.gz"
  version "3.53.0"
  sha256 "851e9b38192fe2ceaa65e0baa665e7fa06230c3d9bd1a6a9662d02380d73365a"
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
    sha256 cellar: :any,                 arm64_tahoe:   "eb0597f2fc461458b99d9988915a1ec6c55f9a503a63d30cd8f55db661160f34"
    sha256 cellar: :any,                 arm64_sequoia: "70310585b41dbac8b84540f061b12882490cd55b4101982d3aa33155d8b7243d"
    sha256 cellar: :any,                 arm64_sonoma:  "36080e3273614fe3d606ff0bd5bb090ad33c19f186ba44c35807b8f97afa15be"
    sha256 cellar: :any,                 tahoe:         "109b479dafa7d3170606a3d13795478031baf2b60d2bf77bc1045c4a6a6578f6"
    sha256 cellar: :any,                 sequoia:       "3f6f75a8f1422c1da90f2c07ec9bae606100ab0b3f52422288118a34801230b6"
    sha256 cellar: :any,                 sonoma:        "d1e0f1cc65d426ba689fd0c512d918179b11b9c6be177ddc92b7751c6252be76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f854d0fde3e8a2e8321476fd488f273e69833c672d7d672d3e0b13e3a3c5475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1a29a99fae0bbd1e20ffc396aa6b4e9f47c0dcc11dd88c3d4c18f1de2fa904a"
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
