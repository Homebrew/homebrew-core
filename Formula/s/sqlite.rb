class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://sqlite.org/2025/sqlite-autoconf-3510000.tar.gz"
  version "3.51.0"
  sha256 "42e26dfdd96aa2e6b1b1be5c88b0887f9959093f650d693cb02eb9c36d146ca5"
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
    sha256 cellar: :any,                 arm64_tahoe:   "bff54f7679f4e53d166ef337fb54647344a36444ae792e14be83ab7989d2f2e9"
    sha256 cellar: :any,                 arm64_sequoia: "8a986b66c97e295a5a9908b531528535dd30f23c42bde5cfcbdd258f097d868a"
    sha256 cellar: :any,                 arm64_sonoma:  "0314adaf2cb17e56794d6b242463d3ac812bd3f22041432fa7971c428b1cf1ad"
    sha256 cellar: :any,                 tahoe:         "643e8196600c01c30f2df549062de80ac00cbeefc343ed0fae2bf41c04ff45ef"
    sha256 cellar: :any,                 sequoia:       "24f91d6b794df11ba7ab850db26e79f9c55dd194cda0b1b1a6b8dc9d64778dd1"
    sha256 cellar: :any,                 sonoma:        "0c6f8acf8dd950f87a3f252bf04180372d6fc290106964907a0897156d589570"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54f0c7965a030a8a5b7a149e5b90661f9f982c84617fa66e3f1fa47a1df19438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e1699f85eaa59ffd4c583e6db050fc07d348629e0e5ddcb734456ad89558834"
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
