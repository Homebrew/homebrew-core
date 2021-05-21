class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-3.1.tar.xz"
  sha256 "a55a2975aa119f76983412507e3ddb3fe68d0744e08739681ddc17744e77a4f7"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 arm64_big_sur: "13358880145e64b9abb5aa1b3edd45cbe99fad9513269e71e40015561e274dac"
    sha256 big_sur:       "2dc092a658d47fa3792106517dbc0c8d067f2a43e47444f9e11a8f6dd4d5841b"
    sha256 catalina:      "bbe506b6fe5fc7ef054299d35114508e5bef467c9083880a237b76d4d4a078af"
    sha256 mojave:        "b956b1d6111acfbdeafbeffb42eb715ce39a3fb064238f089f2373d31325c93a"
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
  depends_on "python@3.9"
  depends_on "ruby"

  uses_from_macos "curl"
  uses_from_macos "tcl-tk"

  on_macos do
    depends_on "libiconv"
  end

  def install
    args = std_cmake_args + %W[
      -DENABLE_MAN=ON
      -DENABLE_GUILE=OFF
      -DCA_FILE=#{Formula["gnutls"].pkgetc}/cert.pem
      -DENABLE_JAVASCRIPT=OFF
      -DENABLE_PHP=OFF
    ]

    # Fix error: '__declspec' attributes are not enabled
    # See https://github.com/weechat/weechat/issues/1605
    args << "-DCMAKE_C_FLAGS=-fdeclspec" if ENV.compiler == :clang

    # Fix system gem on Mojave
    ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install", "VERBOSE=1"
    end
  end

  test do
    system "#{bin}/weechat", "-r", "/quit"
  end
end
