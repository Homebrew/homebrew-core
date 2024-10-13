class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2024/sqlite-autoconf-3460100.tar.gz"
  version "3.46.1"
  sha256 "67d3fe6d268e6eaddcae3727fce58fcc8e9c53869bdd07a0c61e38ddf2965071"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "7bd90d0910ec7b1dd2be0421a5a76fff773e26eb6e9416ab885b05bd498e35fa"
    sha256 cellar: :any,                 arm64_sonoma:   "ea8ee59ee1cf5599778ed5ce03f118dfc96cc814f0a8aefa059502101ee45c7c"
    sha256 cellar: :any,                 arm64_ventura:  "0b50035ff0b93300155a67a6c42a1fa2c88e39fc4d4daba4471eda9ac9b3224c"
    sha256 cellar: :any,                 arm64_monterey: "b04e7f909acd9753598e0d00ea3eb5f409d219c8efd48888725812e7ca68bfa1"
    sha256 cellar: :any,                 sequoia:        "79aa45908a8b30d2df1281e07ff3b74e518ee0499dffd171833d43f34029bc0d"
    sha256 cellar: :any,                 sonoma:         "4bfe3c42a2ba2924b898410e70846b46ca7bcf82916c0ff15a92d81d69bb6394"
    sha256 cellar: :any,                 ventura:        "388f362cadde5c691e84a66635ebf101ff21e6e13f4b10981d2632e2aff3bd3f"
    sha256 cellar: :any,                 monterey:       "0f6e20de908628b8b8b761b2c1231650757a508368860a4055fcc4ad8240ba72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "108cff91d8599c1d25f3097655c539c914cce311f19cbef2dd667a56fd2fed40"
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
