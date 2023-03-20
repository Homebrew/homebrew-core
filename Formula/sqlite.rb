class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2023/sqlite-autoconf-3410100.tar.gz"
  version "3.41.1"
  sha256 "4dadfbeab9f8e16c695d4fbbc51c16b2f77fb97ff4c1c3d139919dfc038c9e33"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fedac4380affc3aa80c2cfb95dd7d18007fa9fe5790e4268a57fc1632a91efcd"
    sha256 cellar: :any,                 arm64_monterey: "366a4a81468e064462321a62d46bcb4e896c95fd3fbd85e83bfa8d1d2912b9c6"
    sha256 cellar: :any,                 arm64_big_sur:  "adee1273352badfdac79ba449b1dbc5f4ed99d8954d180c5c56dab6ae7b346b2"
    sha256 cellar: :any,                 ventura:        "1212ec2414bcb28695319fd08509e3f5d3af294f83a9c911312b23152bf8adb2"
    sha256 cellar: :any,                 monterey:       "5b1dbce1a64eedf4ed844525ec4a075d365db7c44d75e1c454b77c7d2aaf2d6a"
    sha256 cellar: :any,                 big_sur:        "623b199afe5868a66e2177958ed264baf5960005746c0bd137fd6a68e9fc10e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71f42ab4f5ae028ff88bdca8e6d4ad430260f9e20105056dfe71feff75715ca2"
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
