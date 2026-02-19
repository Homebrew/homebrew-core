class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://sqlite.org/2026/sqlite-autoconf-3510200.tar.gz"
  version "3.51.2"
  sha256 "fbd89f866b1403bb66a143065440089dd76100f2238314d92274a082d4f2b7bb"
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
    sha256 cellar: :any,                 arm64_tahoe:   "fbf2db6ccb3eba4b8bd5ddf431a4e9093036d57023513e87547c49ce4756f27a"
    sha256 cellar: :any,                 arm64_sequoia: "2544636d73aece26687053032cfeac0af941d19f9e5139637b56bed4cab464f6"
    sha256 cellar: :any,                 arm64_sonoma:  "70597cfe4ccfd011381cca07892501a6969346b205a33ef2d43b2879a8567a4a"
    sha256 cellar: :any,                 tahoe:         "f1139eb67c15445dfb74eac36522f92c8e67e1588f31e6e62e73402eb34680fd"
    sha256 cellar: :any,                 sequoia:       "322926ca618a6a9662f6711ba34c47f2f64eac14535e937e4276e98f5252b2b9"
    sha256 cellar: :any,                 sonoma:        "db4758cdd523d0df9197753ce2214788b720529bc95a60966d388ebd3ef961be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e05430910d42ddae0ed0cdb2e30da8594d73f9032edcc4f1351ef58d78dd3d2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6689656c037d1bd3b4683309fc12fa8ef5618c1a9eceffe20e597aebfc1a22e"
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
