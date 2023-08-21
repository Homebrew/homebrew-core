class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2023/sqlite-autoconf-3420000.tar.gz"
  version "3.42.0"
  sha256 "7abcfd161c6e2742ca5c6c0895d1f853c940f203304a0b49da4e1eca5d088ca6"
  license "blessing"
  revision 1

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9fd1693db4fc5e3c2dbe0d836e9a5c6199beceb1dafac2e4eae250e848cfb1c8"
    sha256 cellar: :any,                 arm64_monterey: "a507945a01732e928fc4fb9866d96bba234184ec380e938b6663c601c7509639"
    sha256 cellar: :any,                 arm64_big_sur:  "e78fc4425fe78bf1a9cc60d1987566c69af7cf46eb9230143329e096b9e6c5a1"
    sha256 cellar: :any,                 ventura:        "23b4e8610b9a6f6ddd6457e015b49ec8c9562ae5fb3a259fb02da78365ad293a"
    sha256 cellar: :any,                 monterey:       "1fddb3a8bc04073da2177031e9fd0ec68030aa3913aee80aa23d58f2f7dacc11"
    sha256 cellar: :any,                 big_sur:        "4a6bec3a76d437b72e13ed44aabfa1d982d623cfb8d780c1758d2958f5cc5c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2baf2a34e6843ec8bf5cecd715a1dc95e858b4695f4669dae124d532234f1d8"
  end

  keg_only :provided_by_macos

  depends_on "readline"

  uses_from_macos "zlib"

  def install
    # Default value of MAX_VARIABLE_NUMBER is 999 which is too low for many
    # applications. Set to 250000 (Same value used in Debian and Ubuntu).
    ENV.append "CPPFLAGS", %w[
      -DSQLITE_ENABLE_COLUMN_METADATA=1
      -DSQLITE_ENABLE_FTS3=1
      -DSQLITE_ENABLE_FTS3_PARENTHESIS=1
      -DSQLITE_ENABLE_JSON1=1
      -DSQLITE_ENABLE_RTREE=1
      -DSQLITE_ENABLE_UNLOCK_NOTIFY=1
      -DSQLITE_MAX_VARIABLE_NUMBER=250000
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
