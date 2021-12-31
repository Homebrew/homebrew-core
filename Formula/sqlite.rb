class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://sqlite.org/2021/sqlite-autoconf-3370100.tar.gz"
  version "3.37.1"
  sha256 "40f22a13bf38bbcd4c7ac79bcfb42a72d5aa40930c1f3f822e30ccce295f0f2e"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0d2329362912c8647c9c10bf4774395e025d11a8a9d600ca0091a38f096bdec5"
    sha256 cellar: :any,                 arm64_big_sur:  "9b8c17c2897be9e45b87b6adcc458ab4c8e851cc9e282fe4809fe68a3bf60fe1"
    sha256 cellar: :any,                 monterey:       "a09ed4541fe1627ce6ce47cad66c60ff4855228f85db20b78af382ea0b6694cd"
    sha256 cellar: :any,                 big_sur:        "ae0b38a858aff75dc98207805e5eaacd285736520cbf4292b70fb910a22c1685"
    sha256 cellar: :any,                 catalina:       "affef158fad07031c3914f8129c437164e67b3a52018ab97903f742498be9334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44c9a5499599963dce121716608baed52b9143370134eb243c046a5458c79fb0"
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
