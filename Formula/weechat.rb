class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-2.8.tar.xz"
  sha256 "553ea295edad3b03cf88e6029c21e7bde32ff1cc026d35386ba9da3e56a6018c"
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 "223ad4e5391ad24e5023d8bc606884b1fa6010378c9d13c6eea921dbba26a506" => :catalina
    sha256 "fc01a3d05a0c8de64f7a5739f6328c1767639dc2886a6f77bb8f7e36e1b049b9" => :mojave
    sha256 "99d03a315581d96b6e5eb50656573cc6f39cad40c55ad9566e45b22f654b23f6" => :high_sierra
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
