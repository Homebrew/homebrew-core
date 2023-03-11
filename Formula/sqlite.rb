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
    sha256 cellar: :any,                 arm64_ventura:  "72073c161c9ee425437a6017ea334ce86d8151c214dbd3607ebf8bfd85038995"
    sha256 cellar: :any,                 arm64_monterey: "85b3532c30cdb3640a0d9066141a16ab84df6f803d4330f1134f8943a9e42f08"
    sha256 cellar: :any,                 arm64_big_sur:  "3ade7ae815b207b3588ff97940df261b45352af07a2c7630797a810e859708c0"
    sha256 cellar: :any,                 ventura:        "d8059dda928619bf5c0a3e5fe4762472afa36433fc9d0f961a4b6ad9da480fb7"
    sha256 cellar: :any,                 monterey:       "6d67a64201a6a5a5550938a6979ba1f6c00e385123e3b76dd996526a223de4c2"
    sha256 cellar: :any,                 big_sur:        "7810110320523ecb1afb35a2830cbe363cbc1a3b1bd07c9dec60871617134880"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a62e7b7e603287959e00b45e032d7c0a8de5d46a6acd40680ca575f91df0098"
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
