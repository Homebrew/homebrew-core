class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2025/sqlite-autoconf-3500400.tar.gz"
  version "3.50.4"
  sha256 "a3db587a1b92ee5ddac2f66b3edb41b26f9c867275782d46c3a088977d6a5b18"
  license "blessing"
  revision 1

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.tr("_", ".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3e335d368e5121928ce36ac773e3288f4fb6c41101444f1b4af4d1dbe659327d"
    sha256 cellar: :any,                 arm64_sonoma:  "d20db6b67ea5eeb691e962d9debb173ce2cac67ff146976344939be7a61cf85a"
    sha256 cellar: :any,                 arm64_ventura: "d70fbfa87ed2b4a1f87f2e32161b123eef4f050def931d0c47035059fed98e1f"
    sha256 cellar: :any,                 sequoia:       "157c87855aa5b6a4def7128ffdbf66db6b24aedbd09ca161611fa55b05af7166"
    sha256 cellar: :any,                 sonoma:        "0ae196f71bc7b10b5abe93f858f7bc776c009378a1e928d72c6cab9f8f98004e"
    sha256 cellar: :any,                 ventura:       "4540fe4b03ffc83aa035e6605990ccf12754516541af33590e574769551b6b13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cee589f54c79931019906ee01d3749a9337c4793756188500fb6c71a40425e5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfedb542431d934037847ab42457983f715fa83619f8fe7cffeb67f049f3c718"
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
