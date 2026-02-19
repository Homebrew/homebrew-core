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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ef7576d687d514cf3e6691537bee8e66eaca106ef598ad5cf07c4e20d520aecb"
    sha256 cellar: :any,                 arm64_sequoia: "9bc67271da98897902daddd9417ae566a904f20d4b418472b482588a9fb77e17"
    sha256 cellar: :any,                 arm64_sonoma:  "c26a1c42c2b747053113d927ae7c2e231163b4d9f8c695ecec1dc05bf3e041ac"
    sha256 cellar: :any,                 sonoma:        "1a219550850f7e7aba34e7695ffd1768141bb8ee469a0ab81f19c66292c33fec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f2c84110c49b8b78f0c9cba7c38a4164f42e6d7ec370b8ac7deb83e70d978ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c3e2942b9b3d486a777ca95d5303fc556ae08435e60a2fa0f099a21d3db473b"
  end

  depends_on "sqlite"
  depends_on "unixodbc"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
