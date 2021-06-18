class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-3.2.tar.xz"
  sha256 "39a8adf374e80653c9dd2be06870341594ea081b3a9c3690132e556abf9d87a8"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 arm64_big_sur: "fbd66c10bc0224c5d21fbfb08c96f96d9ae2c014945fea2e1298ec0fff0b4030"
    sha256 big_sur:       "0261a4b52e5fd25067fc2d9af3af59090cadd466c36cd69fcf7a635fffcf0bd6"
    sha256 catalina:      "4d939d2a34065cdae47590d50b6b2aa3c7595b79af0957cb7535c7ba25ee0255"
    sha256 mojave:        "d9af6b42a994c3a8ee5632563dd5cc285395d0dcaa908f7b928ce5c1e3e845d7"
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
