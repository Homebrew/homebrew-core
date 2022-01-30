class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-3.4.tar.xz"
  sha256 "7cd3dcc7029e888de49e13ebbcc3749586ff59c9d97f89f5eeb611067c7bb94c"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "c1c9f65f6c343bbd625dac9607d443c277a854f55ebf51ef37b92de0f80d4f76"
    sha256 arm64_big_sur:  "1309d99b85db77c50c7b292c6e81d68df82497e69339323d5b299b2ddfb676a1"
    sha256 monterey:       "7336cd13c98d0f443c3d5f1ab202e237a4d50d3f651b1cf8e5b98d4cf983755b"
    sha256 big_sur:        "886971ad9b19c9e9a1f326d87609d99cf2875d2c584c3346d3b6b57276b49152"
    sha256 catalina:       "62ae5119738167c6686f23a1deddcfaaa995b2c5c8e43716a49df92df6eacf9d"
    sha256 x86_64_linux:   "9b4e1e7b7487683d97b9473fbaa4e58a5f86a8272d80744075def1d37f28590c"
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
  depends_on "python@3.10"
  depends_on "ruby@3.0"

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
