class Sqliteodbc < Formula
  desc "ODBC driver for SQLite"
  homepage "https://ch-werner.homepage.t-online.de/sqliteodbc/"
  url "https://ch-werner.homepage.t-online.de/sqliteodbc/sqliteodbc-0.9998.tar.gz"
  sha256 "fabcbec73f98d1a34911636c02c29fc64147d27516b142e8e132c68c05a6065b"
  license "TCL"

  livecheck do
    url :homepage
    regex(/href=.*?sqliteodbc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e7b517422475c70e7177c1d8cdb3e02dead73d2ce0e1987097074c9695f95959"
    sha256 cellar: :any,                 arm64_monterey: "8df10001bbf7daf13bd5b3d65f75edc7ea2b2dc6989873de14b957ad9bf7a4b1"
    sha256 cellar: :any,                 arm64_big_sur:  "1024f38c091e42d18128dbfba82ee5a9a41e46670383f714df325303bda5b415"
    sha256 cellar: :any,                 ventura:        "b0089b13a9504698398c2bb0be71754e00dd5f9325aec64be85800a0d5e3f6b2"
    sha256 cellar: :any,                 monterey:       "df3e249a7780ffe6178fd754655a6313c4526c9f6eb06cf169c5776a669d749b"
    sha256 cellar: :any,                 big_sur:        "5f98876aef9733997e750451ee0e3db30cc2bd1f371aa690f08d7e4038f11958"
    sha256 cellar: :any,                 catalina:       "d0105cc73d44561e636923adb520710cdd7e0db835c6b31f151fe8a66a1b4fcc"
    sha256 cellar: :any,                 mojave:         "6499af774d13212bf19dfdbd14c18feadf516a5d6afbd2ebe7718d99db1723eb"
    sha256 cellar: :any,                 high_sierra:    "6220e24f32b5b26c5c983c9f9fb1aaa6aba7c13cad44a7500ecb72c7d7723a80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f77f39a029206cffd13e303b4aec9705b413d3c8f4d3c1844d8e1634a48de82"
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
