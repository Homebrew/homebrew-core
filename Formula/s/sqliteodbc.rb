class Sqliteodbc < Formula
  desc "ODBC driver for SQLite"
  homepage "https://ch-werner.hier-im-netz.de/sqliteodbc/"
  url "https://ch-werner.hier-im-netz.de/sqliteodbc/sqliteodbc-0.99991.tar.gz"
  sha256 "4d94adb8d3cde1fa94a28aeb0dfcc7be73145bcdfcdf3d5e225434db31dc8a5c"
  license "TCL"

  livecheck do
    url :homepage
    regex(/href=.*?sqliteodbc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "80cc2b8469f6718e6228b4465bdec52fa66d37731c6e80db40f2bfad339ccc70"
    sha256 cellar: :any,                 arm64_sequoia:  "61de52252306e865b3c14e8ef775b1c4ccd22da7c7e5ea2b0f91c54c7877e08c"
    sha256 cellar: :any,                 arm64_sonoma:   "015eee63671fc01c778e6e663529ace8d63a7d71f2654be9b9556ccd9e29154f"
    sha256 cellar: :any,                 arm64_ventura:  "dd59b3db3e696d538dea72e84c5602c17f24fe119104a705a0662adee36547e0"
    sha256 cellar: :any,                 arm64_monterey: "8ed399c5e2eb6497973a1f8576febd0a60c4470fbb16e29b2b919aa875bf3565"
    sha256 cellar: :any,                 sonoma:         "8512cd23bae8277c72c3b432749364595234724a8b20f201a98f61497edb2f3c"
    sha256 cellar: :any,                 ventura:        "3aae3791f2bceb04e3d9261ebbcb2c639491c530628ac2632c2a9cf64c2c7b1a"
    sha256 cellar: :any,                 monterey:       "1d3e62b967aa75bb3ea2f4db75e350dd920d2210edc4c268600313311d255476"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f3105e72f81fb1c85b2cd028b0063e6e413549706f4a7e4286f48fb9fa420144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a61acd439d7530e91d25824689b621be04831e3f28aa00f28cb0d7d810a5afb"
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
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
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
