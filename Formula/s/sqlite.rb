class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2024/sqlite-autoconf-3450200.tar.gz"
  version "3.45.2"
  sha256 "bc9067442eedf3dd39989b5c5cfbfff37ae66cc9c99274e0c3052dc4d4a8f6ae"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8a21e8f51c7ba1f64fc30182f5e70fe0e3c23d0f58dfd250063684fcc0781c8e"
    sha256 cellar: :any,                 arm64_ventura:  "61977e6c4e5b7606e61792f89d8bddaef28250695c74c73fdd9799924fa92c6f"
    sha256 cellar: :any,                 arm64_monterey: "5e370755b9252a8e9161182b9c9ae68fa46077d9d4187af225c1d0e8304af970"
    sha256 cellar: :any,                 sonoma:         "12a4ffd47ab34b8fe8edf219cb185632d93389580f5958fcda87c9664cdfe498"
    sha256 cellar: :any,                 ventura:        "1cb514c931c7be45e0ebbb930982a1a284daea50d6ae79ec42cfe6497bd0ab6d"
    sha256 cellar: :any,                 monterey:       "383384b8a1d8858b42bd56f71305e457ab96f0e5420784c7a4c514c417e012d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3a7b442467282a4811ff21c8487d7a632e85c70cb1d3d9c6dadaaf39c973579"
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

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-dynamic-extensions
      --enable-readline
      --disable-editline
      --enable-session
    ]

    system "./configure", *args
    system "make", "install"

    # Avoid rebuilds of dependants that hardcode this path.
    inreplace lib/"pkgconfig/sqlite3.pc", prefix, opt_prefix
  end

  test do
    path = testpath/"school.sql"
    path.write <<~EOS
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
      select name from students order by age asc;
    EOS

    names = shell_output("#{bin}/sqlite3 < #{path}").strip.split("\n")
    assert_equal %w[Sue Tim Bob], names
  end
end
