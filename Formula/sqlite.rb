class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://sqlite.org/2022/sqlite-autoconf-3380200.tar.gz"
  version "3.38.2"
  sha256 "e7974aa1430bad690a5e9f79a6ee5c8492ada8269dc675875ad0fb747d7cada4"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5b6f859aac9956913fdd868f276a381b23aec02b48cc2b12a9af6bce544ebca9"
    sha256 cellar: :any,                 arm64_big_sur:  "8d0051f26adc3628b1e3c6f0970dd476a064498fbaa5b366dcf0ef4ad7315665"
    sha256 cellar: :any,                 monterey:       "3707d37c2cb1f0781ffb44e83e6ed5977f66e02d8f85af65946fd8413f473efa"
    sha256 cellar: :any,                 big_sur:        "26668897544eb6179ccb641a0cdbe8cdb906bf9c6749e588fb21c8b8a2faa8db"
    sha256 cellar: :any,                 catalina:       "caf153da2b6f71840e4fc0ee6bcb864c4ae8929f6cfde2533dafba1c26d2ad16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "401a896a0efb4ef35bc8254c0de710db8275707c364b7ab153b94b6c290fc7a9"
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
