class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2025/sqlite-autoconf-3500200.tar.gz"
  version "3.50.2"
  sha256 "84a616ffd31738e4590b65babb3a9e1ef9370f3638e36db220ee0e73f8ad2156"
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
    sha256 cellar: :any,                 arm64_sequoia: "0721dd40b60d85e21ccb9020872951c567a7d68d987da83cee478667e63862a3"
    sha256 cellar: :any,                 arm64_sonoma:  "198026e2cf368f93121c3a8ecaa9d88bedfa43e43ad89ee66f6de348cdeac7c3"
    sha256 cellar: :any,                 arm64_ventura: "36d0e055ec29e4d6b5ad0abddaaae526c8ad558f235ebc002f84cffc630d1d0a"
    sha256 cellar: :any,                 sequoia:       "577f8aa80ca4950b15d8d9485d223129e7de442229d4d0065cf6c648be1dced9"
    sha256 cellar: :any,                 sonoma:        "2c0aeb819d9a5767df1ff3b44ee0afc725ef993ce6dd0674b3f564837c74f1c6"
    sha256 cellar: :any,                 ventura:       "411a7dc6e0e0ae5e3f274e9561dc621807bd5873fda0bca97c744e3107c0e270"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3eac4d09b06b4cd58b6418756be0c9273a8945cb581ac161060a259a060ae079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96ba768b2461d25e855fbaf29002fd907ad124ed793ef8f76f446e37ff86728b"
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
