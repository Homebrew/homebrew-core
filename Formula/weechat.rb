class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-3.1.tar.xz"
  sha256 "a55a2975aa119f76983412507e3ddb3fe68d0744e08739681ddc17744e77a4f7"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 arm64_big_sur: "8f7cd8d76ae449f66703e7da1e57ca27f9a6635742e18937092b2b173fff50af"
    sha256 big_sur:       "d94b5b25150947e9f1cd5343206859971acdf740d5ceee7d4d7a33b7e0f9485b"
    sha256 catalina:      "cc6b05e6233b5cc7f1d8e05d2844ed9981f8a35c3a330ae5eb96af50b39daf2c"
    sha256 mojave:        "643e7c45958a9ea3d42a1a9b67dab4d58f185c275a025916f75b9cb54f316ee0"
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
