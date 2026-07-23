class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2026/sqlite-autoconf-3530300.tar.gz"
  version "3.53.3"
  sha256 "c917d7db16648ec95f714974ace5e5dcf46b7dc70e26600a0a102a3141125db0"
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
    sha256 cellar: :any, arm64_tahoe:   "31568d1c8cdabc459b16f582887e6b28613970422c9769253c9fa67cc6356349"
    sha256 cellar: :any, arm64_sequoia: "91bdb4c104eea3e2290667873b1409f5215f841b93b299ad48e09fd59f480f17"
    sha256 cellar: :any, arm64_sonoma:  "f287c9330c9275791c6bb39e631cd637a1ea396241139a94db8ee7f8b42443fa"
    sha256 cellar: :any, tahoe:         "701747ffe44b3b8ed135ea2ae328b13d7bea7777f347d9b781ac82e20a8da6c2"
    sha256 cellar: :any, sequoia:       "3caa3f4db5d3742a657af8d5dab9ebdec461453a48d072b1ecf8023a0264ed27"
    sha256 cellar: :any, sonoma:        "119c67bfc81bd74c4b00e041f42e8667b47a35441e7ca7153941f22f8ae66526"
    sha256 cellar: :any, arm64_linux:   "7f7b77dc7e268911201c98cb00773d866c83955f0171937cdc5b7eee10494e85"
    sha256 cellar: :any, x86_64_linux:  "f0c136cfc6e31fbcf1d0960a4771376ac603c27807f520fad54748f9337665be"
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
