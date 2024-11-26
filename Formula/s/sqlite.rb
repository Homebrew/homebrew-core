class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2024/sqlite-autoconf-3470100.tar.gz"
  version "3.47.1"
  sha256 "416a6f45bf2cacd494b208fdee1beda509abda951d5f47bc4f2792126f01b452"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "22aa891d3868b2ff3cf5b2fff0b7c3bdc43fa9cf0c2f7047b213710e2710fbdd"
    sha256 cellar: :any,                 arm64_sonoma:  "0a8421e2daf5553cdacec61126c2f654fc4ed5687dd4e0784f1d7240a1d6085d"
    sha256 cellar: :any,                 arm64_ventura: "0bcd7e4d48a0a9c721a93ee7ea4f3a2c3461c900c7595c7c2b323168398b1a50"
    sha256 cellar: :any,                 sonoma:        "296329a5f36f981fda8c7870c9e591d08c84e84d989d91eb92a7fcae1cc1e448"
    sha256 cellar: :any,                 ventura:       "3ec83a8caed77476623d709d6d980698f09c0fb267907a2bf8323e6fc5b8439b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae9ae05a9ea1d51a5c3a93684d4913bfec54c9afcd1efb07c0abb32d0f9abc2c"
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
