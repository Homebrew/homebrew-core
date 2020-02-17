class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-2.7.tar.xz"
  sha256 "56fc42a4afece57bc27f95a2d155815a5e6472f32535add4c0ab4ce3b5e399e7"
  revision 1
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 "e76d881438e6f0cce0656209c9daaa8aac80e0d3b01e949c814d2c88bcb3b9d9" => :catalina
    sha256 "8134dae00d238e4275e4f79df1f25411379b9dd752d9c15a81b721b14c592249" => :mojave
    sha256 "0f61694c5639a90443b0edf15f229d10d0a102a3fe7313616d3a41304a333ac4" => :high_sierra
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
