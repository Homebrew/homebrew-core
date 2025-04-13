class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2025/sqlite-autoconf-3490100.tar.gz"
  version "3.49.1"
  sha256 "106642d8ccb36c5f7323b64e4152e9b719f7c0215acf5bfeac3d5e7f97b59254"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "757c3d60f4d35fe1c3336207d63992fc804fa6ddd2c40ebb84eb7bfa07bc69e1"
    sha256 cellar: :any,                 arm64_sonoma:  "49a9ba828b871d0aca0f9093478971763172c20c7c3184bab42b5f0dd579268f"
    sha256 cellar: :any,                 arm64_ventura: "bc9452d380a2b553d773112d283f96386bf7acd7ba9f41186ef13b01e1e0f01f"
    sha256 cellar: :any,                 sequoia:       "e716021f04832c5efd6d6c54f6577062dd3e7c61338df31525853f69b17d2bab"
    sha256 cellar: :any,                 sonoma:        "d6447132dbe25963619d8113df0c519b97c0781cf0dad090e21571a0c1799a44"
    sha256 cellar: :any,                 ventura:       "313fe6fe6590c79082a7d92810214166a580d8f9c21616f3bcec568db1cf3a1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36f28aee864eb8512612ab12219811863e64780a1d37b22211939677c993cbb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "988cd498cfd373e932dadd1893ef46b8b2ef11cdb12f802260a362dbd3e8942b"
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
