class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2023/sqlite-autoconf-3420000.tar.gz"
  version "3.42.0"
  sha256 "7abcfd161c6e2742ca5c6c0895d1f853c940f203304a0b49da4e1eca5d088ca6"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c9b11a8dd4fd8996ba24018f60c21ccf494bcc8525cc5669ae09d73d096f5ed3"
    sha256 cellar: :any,                 arm64_monterey: "98b205e8fea377e8be33e7164954d34897bb8e272a2bf4747fa18f5df3f7b419"
    sha256 cellar: :any,                 arm64_big_sur:  "229f5e3a47df464bfec8e6f59e970f7a2755c9b948e0fb81a6bd27aa070aa769"
    sha256 cellar: :any,                 ventura:        "4bbf2bd9382c9f257712e60ff36fcddc7de69fcb95a06006558673f6985da85d"
    sha256 cellar: :any,                 monterey:       "ab99129920b56e88f1d89bbcc07bb3f3278575029213fb070f4220b5bcd9f8d9"
    sha256 cellar: :any,                 big_sur:        "f0ccc2c64cc793a160be644fbb654074f42750735488702169a1353d3efc1326"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8226fd550248842674a281032e758b0f2fd1f0d7dd543f6eb78512b1edf00ad5"
  end

  keg_only :provided_by_macos

  depends_on "readline"

  uses_from_macos "zlib"

  def install
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_COLUMN_METADATA=1"
    # Default value of MAX_VARIABLE_NUMBER is 999 which is too low for many
    # applications. Set to 250000 (Same value used in Debian and Ubuntu).
    ENV.append "CPPFLAGS", "-DSQLITE_MAX_VARIABLE_NUMBER=250000"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_RTREE=1"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_FTS3=1 -DSQLITE_ENABLE_FTS3_PARENTHESIS=1"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_JSON1=1"

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
