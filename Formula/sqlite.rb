class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://sqlite.org/2022/sqlite-autoconf-3400000.tar.gz"
  version "3.40.0"
  sha256 "0333552076d2700c75352256e91c78bf5cd62491589ba0c69aed0a81868980e7"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "ee436a5df9626002b616689af55c886424d1893088825d7072930bca38c49c8e"
    sha256 cellar: :any,                 arm64_monterey: "8b94b22c3f3f45b1946cd1401ceebe18b82a1562a35fbaa8169746b306a71cad"
    sha256 cellar: :any,                 arm64_big_sur:  "7c113e391a0271b56e2d7bc8b5c302e9129297148808060cd3e58b6158007618"
    sha256 cellar: :any,                 ventura:        "4a5361493f374e30a23ed88e58e1d6a470863b000c692b78f9182bffd7f6f207"
    sha256 cellar: :any,                 monterey:       "eae786ad782fb305cb1bfad22b37c52efc4c1f14614f29f7e3876dd048b83dd9"
    sha256 cellar: :any,                 big_sur:        "d34bcac10466e55c1007458340a031b3092bde9ca5734573a161fda4d80c1daa"
    sha256 cellar: :any,                 catalina:       "3b9322b54ae7634e0e8cd5d0433ea6972a8f79ae5264f864244c87586b8494ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be1ead07a071d92f6a6ee0f4964df1d796f30966fc405e6396281f9bd0738c40"
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
