class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://sqlite.org/2025/sqlite-autoconf-3510100.tar.gz"
  version "3.51.1"
  sha256 "4f2445cd70479724d32ad015ec7fd37fbb6f6130013bd4bfbc80c32beb42b7e0"
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
    sha256 cellar: :any,                 arm64_tahoe:   "25fdc37d81e22ba7340c49e4bd9cd560d93af9c20695918a469aad55aa974440"
    sha256 cellar: :any,                 arm64_sequoia: "3ba6cfbf260d4a9b6d3bae51d41f0d7d0f636d86d826afbf3ae9baf59a0bd301"
    sha256 cellar: :any,                 arm64_sonoma:  "ef23f28863205ce03bd94a10df8cb85e77b9f9a0884258759816d88326b46df5"
    sha256 cellar: :any,                 tahoe:         "e5ced7a284a62008eec11a245cf8652ca320840d4926ec138fa3ece0b25ad90d"
    sha256 cellar: :any,                 sequoia:       "2422b6f9bab98baab5c64e76d91ff1cd491f13a42380e961fd81df3d5a7d2272"
    sha256 cellar: :any,                 sonoma:        "10d91e6f2d092fa72fd5a32b355a14652b71d4c7a2514096794178fe0ab7c56b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca4236260a51a30ed3c31cb8989b0cc2d435f668979ea2b488290e4ec2e24374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e77d3f2b1bce539331891c04bb5fd79972f79b9b193218765f2a5b48790d9649"
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
