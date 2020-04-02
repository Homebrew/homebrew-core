class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-2.8.tar.xz"
  sha256 "553ea295edad3b03cf88e6029c21e7bde32ff1cc026d35386ba9da3e56a6018c"
  revision 1
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 "60b72321ee167483c30f4b8f41b30f3da8a36ae02fc58bd35fc55a265d2725d7" => :catalina
    sha256 "f8a9685d17d5d8a0bb32af3d0625a33fa8003251859aa8ab0c73fa81da9d4a65" => :mojave
    sha256 "01c768ce156a997b6d6d6fbd93c95ebd389f32682d2988f11eba04e93bf8dde5" => :high_sierra
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libiconv"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python"
  depends_on "ruby"

  uses_from_macos "curl"
  uses_from_macos "tcl-tk"

  def install
    args = std_cmake_args + %W[
      -DENABLE_MAN=ON
      -DENABLE_GUILE=OFF
      -DCA_FILE=#{etc}/openssl/cert.pem
      -DENABLE_JAVASCRIPT=OFF
      -DENABLE_PHP=OFF
    ]

    if MacOS.version >= :mojave && MacOS::CLT.installed?
      ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version)
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install", "VERBOSE=1"
    end
  end

  test do
    system "#{bin}/weechat", "-r", "/quit"
  end
end
