class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2023/sqlite-autoconf-3430100.tar.gz"
  version "3.43.1"
  sha256 "39116c94e76630f22d54cd82c3cea308565f1715f716d1b2527f1c9c969ba4d9"
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
    sha256 cellar: :any,                 arm64_sonoma:   "204074e0aea3d5046e7520ebc9c9f926d0495c99ab2f836f5b6f438dc35023a3"
    sha256 cellar: :any,                 arm64_ventura:  "81259fc63f4628081719fff9be2a710890743b397c3efcc127963e4e7f881d5e"
    sha256 cellar: :any,                 arm64_monterey: "d45a06ea7fd9215bfaa84ac5666ca3457e22f55061ed068bb4c2a047f3bbbdcb"
    sha256 cellar: :any,                 arm64_big_sur:  "657349fb05058b07f1167c63736d090461a4a23cc846e2d002f9cbba7c14c81b"
    sha256 cellar: :any,                 sonoma:         "011e0229ba52b236336865293b4145345e63df8f099c38b35389454a7f2f3786"
    sha256 cellar: :any,                 ventura:        "21a077eb227087d2e65580e34d306eef9086d17845d54df13db051a73d1e8e71"
    sha256 cellar: :any,                 monterey:       "15ef687cca6b7bb5f1653c5abc66524806cda68d3435f86a84685ac915e7daa2"
    sha256 cellar: :any,                 big_sur:        "f5bc709e4fdec42f08af5773f6524e07b8705cfc2fbea1acb797f81dcbfb5931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "619b4108b279cc97be34e246a70a0a57c74b1db30d10c050da15a6695cfe8427"
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
