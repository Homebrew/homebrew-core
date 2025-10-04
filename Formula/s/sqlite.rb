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
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "31e1f0e39f81417f6c13a81881077df7368fbb3c53b8af5ff5f6bae9e0f7c44d"
    sha256 cellar: :any,                 arm64_sequoia: "ac752e123cff9ffd69bfd3477fb151b8df8363c94b9f6a14ba1a6443b62964e2"
    sha256 cellar: :any,                 arm64_sonoma:  "99c818a03cf2392120ba9a9375f4d42e95bacd5e498c72a4679a0158e5d09598"
    sha256 cellar: :any,                 tahoe:         "2a2bb78a7a499c34c5dbce0ac8d97c11de25c6cbf69354e7b0e5bbd53a1ea16f"
    sha256 cellar: :any,                 sequoia:       "6c3265b83d4f30bde5b89f3b0138b0eb8c4c1db12a08f61071c87fecd7bc2474"
    sha256 cellar: :any,                 sonoma:        "7fb7b19471eb64e746e4c554a8c6b7ad6a42a098cbcae4593cda256e6d17595d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d50fbc199067fb17f4746ccca988d30e66e873e7846ba60f23055263eefd2fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d501561e75552df13a16be24d28edf34bb85215ffae73b87d75b9c58308dd360"
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
