class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://sqlite.org/2022/sqlite-autoconf-3390400.tar.gz"
  version "3.39.4"
  sha256 "f31d445b48e67e284cf206717cc170ab63cbe4fd7f79a82793b772285e78fdbb"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6bdbd6a23d81f9b99a6a24a598e800279f6557b925165449f599a522ad52fbba"
    sha256 cellar: :any,                 arm64_big_sur:  "dc0ce6a29888b6e0a6182f3b3c82a9e20ba8965a22680c272468c857b903c016"
    sha256 cellar: :any,                 monterey:       "dead8c9a98fec5c8bacdb4a852281e7dba98c932f3a84d1be08373ca4aae50ef"
    sha256 cellar: :any,                 big_sur:        "cc1847edaf1a3b0e754fa4606e69be987603ee64adf477e531b726a0e040fac8"
    sha256 cellar: :any,                 catalina:       "48cd92147d5f950accb03e9f7fec2f7124a3ade875fcdaf63b5ce947274200c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32b13296bfbcf213b279ab16dbcdb5151bd87733119b8c67123c6b453850a628"
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
