class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-3.7.1.tar.xz"
  sha256 "c311c9de9f5d87404b667e0c690959388295485bce986fac4ab934ebd43589aa"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "f1ea6c50ba3c3dfbc58005c37106de92115afaee632c61b9103892239ce36551"
    sha256 arm64_monterey: "540376a4064b7bc874b8df0fc4b337a8d527e422396561e791f473df0820ef9f"
    sha256 arm64_big_sur:  "9be093b738588fe3e928e2f58396787bc2beeffb9e1f85032b1659e8b830ef56"
    sha256 ventura:        "5ffbaa90b8a56f9092d19e10872d60055f7112028b62a2c061e82c26ef8b4648"
    sha256 monterey:       "4349087b698ed8380bc028ce5ef555b12679e0af6a08d72240d442f81a078b70"
    sha256 big_sur:        "70f76462cd9e24a619475437175d195d8fe56a4febc7deaf68ff6bc16910b7de"
    sha256 x86_64_linux:   "f18a6c85fa0f462e55e345fe3ff614d541f718fd4c6d8669a0f0b11dfdf4fdff"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python@3.11"
  depends_on "ruby"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "tcl-tk"

  def install
    python3 = "python3.11"
    pyver = Language::Python.major_minor_version python3
    # Help pkg-config find python as we only provide `python3-embed` for aliased python formula
    inreplace "cmake/FindPython.cmake", " python3-embed ", " python-#{pyver}-embed "

    args = %W[
      -DENABLE_MAN=ON
      -DENABLE_GUILE=OFF
      -DCA_FILE=#{Formula["gnutls"].pkgetc}/cert.pem
      -DENABLE_JAVASCRIPT=OFF
      -DENABLE_PHP=OFF
    ]

    # Fix system gem on Mojave
    ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/weechat", "-r", "/quit"
  end
end
