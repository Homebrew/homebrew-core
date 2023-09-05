class Sqliteodbc < Formula
  desc "ODBC driver for SQLite"
  homepage "https://ch-werner.homepage.t-online.de/sqliteodbc/"
  url "https://ch-werner.homepage.t-online.de/sqliteodbc/sqliteodbc-0.9999.tar.gz"
  sha256 "a8ac240e80ff2354a0e0e9ab4d3b567192ae4f3bf5d29244478663a316024732"
  license "TCL"

  livecheck do
    url :homepage
    regex(/href=.*?sqliteodbc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "55af98413216d502d0cfbd87681c8961eef96515a8df22819234b4b2f600c906"
    sha256 cellar: :any,                 arm64_monterey: "ba182ccbe7cbd3de486f7ac7647605076f63567b7f9565bf0c8bf019413d758c"
    sha256 cellar: :any,                 arm64_big_sur:  "ea5c59632a50b4fbc760444c295c9a39e79de33457a6c719f8c86395b6bebcdd"
    sha256 cellar: :any,                 ventura:        "e5561ee6daba6e6aabfe05104fc6059133e274e94d06cd01c4721819ef376418"
    sha256 cellar: :any,                 monterey:       "449760d73e087195df2f145e10b0876651a1a5029dc854364e1b199d9b2608fe"
    sha256 cellar: :any,                 big_sur:        "09adb1cab236efb140cb5e61d53f3fa0c6377e35192a5536de67dfb4d3315085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e889ae35df729577817bade6dd9c445e549a017f9154dcc0cf2b48fdbff7659"
  end

  depends_on "sqlite"
  depends_on "unixodbc"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_arm do
    # Added automake as a build dependency to update config files for ARM support.
    depends_on "automake" => :build
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    if Hardware::CPU.arm?
      # Workaround for ancient config files not recognizing aarch64 macos.
      %w[config.guess config.sub].each do |fn|
        cp Formula["automake"].share/"automake-#{Formula["automake"].version.major_minor}"/fn, fn
      end
    end

    lib.mkdir
    args = ["--with-odbc=#{Formula["unixodbc"].opt_prefix}",
            "--with-sqlite3=#{Formula["sqlite"].opt_prefix}"]
    args << "--with-libxml2=#{Formula["libxml2"].opt_prefix}" if OS.linux?

    system "./configure", "--prefix=#{prefix}", *args
    system "make"
    system "make", "install"
    lib.install_symlink lib/"libsqlite3odbc.dylib" => "libsqlite3odbc.so" if OS.mac?
  end

  test do
    output = shell_output("#{Formula["unixodbc"].opt_bin}/dltest #{lib}/libsqlite3odbc.so")
    assert_equal "SUCCESS: Loaded #{lib}/libsqlite3odbc.so\n", output
  end
end
