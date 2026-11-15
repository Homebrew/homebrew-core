class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2026/sqlite-autoconf-3540100.tar.gz"
  version "3.54.1"
  sha256 "926ef8d3eab93fbf6e06011901273eec076b25594a4e1cdadd50c987f4f6d64e"
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
    sha256 cellar: :any, arm64_golden_gate: "3c8be00f5e80568f00ff389c40e2a738949b08e199935a4538d2f5d054ef4457"
    sha256 cellar: :any, arm64_tahoe:       "813f7e1a708d256259a07a0aa113d1d62bad4909d04e7ad24296900b60d18d6a"
    sha256 cellar: :any, arm64_sequoia:     "38bdb30f8e13a07cdcd86233de9ab4d8db29f2b81cb08c15c202ecea6835ab2f"
    sha256 cellar: :any, arm64_linux:       "5b011ca14e5e52141cc8eb358171ca7c3a20eec06fc5eb3955114ef0b0551e22"
    sha256 cellar: :any, x86_64_linux:      "8783ecd3f534390d2cb8733f0c21d6a9e7ae85802226ee4a891bedd8654271b7"
  end

  keg_only :provided_by_macos

  depends_on "readline"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
      "--with-readline-cflags=-I#{formula_opt_include("readline")}",
      "--with-readline-ldflags=-L#{formula_opt_lib("readline")} -lreadline",
    ]
    args << "--soname=legacy" if OS.linux?

    system "./configure", *args, *std_configure_args
    ENV.deparallelize
    system "make", "install"

    # Avoid rebuilds of dependants that hardcode this path.
    inreplace lib/"pkgconfig/sqlite3.pc", prefix, opt_prefix
  end

  test do
    school = <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
      select name from students order by age asc;
    SQL

    names = pipe_output(bin/"sqlite3", school, 0).strip.split("\n")
    assert_equal %w[Sue Tim Bob], names
  end
end
