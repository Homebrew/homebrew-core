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
    sha256 cellar: :any,                 arm64_monterey: "7cd706bbee6542b7a466c9822e63efb84992f8b81d6951cf3b37048ac7d41305"
    sha256 cellar: :any,                 arm64_big_sur:  "016f5aaa2200dbcec7a7fa83eec1384b491765b6b5185922514a51a757144800"
    sha256 cellar: :any,                 monterey:       "43b72d87a55f57496284e1028986373e918f382b8381e6b29e1b43177759b7d3"
    sha256 cellar: :any,                 big_sur:        "e6cd1fae2fe4326afcfefd56c6dc5555620ac689ffa659a7664d4e510aade003"
    sha256 cellar: :any,                 catalina:       "dcaf8ba01c610349588cf9006b7e68a8efc66b4e6d541f4fc8e5762ebd642136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "860c9a2682f775c298770caa3d667d8f4e598a9693bcdab4a8dd417442197c72"
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
