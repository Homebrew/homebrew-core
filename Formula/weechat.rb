class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-3.4.tar.xz"
  sha256 "7cd3dcc7029e888de49e13ebbcc3749586ff59c9d97f89f5eeb611067c7bb94c"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "626c50ce9831ac1d38fea032162e9ac3b444ae6e6b3d528159c6146d4142fa05"
    sha256 arm64_big_sur:  "879ffa01d42d2f62981b8db7d2171fa1f8971e59a3d41fcf8ce6257537af2884"
    sha256 monterey:       "65d3b1b46f4567301d5ab7e569b1cc29b8cac8c604f917fcc6787b113004173e"
    sha256 big_sur:        "e23f1727ba762cf45dd9269af20e3bfac85fba41e347352e63e22d37aeecaafc"
    sha256 catalina:       "d7d4ead7ff24f9161eec905e91935f621c6ad3c9d3f5405ef2b460a45e4f7ed4"
    sha256 x86_64_linux:   "b80514e1fccb9a2465eb5bc023df2f7bd71650f8e3c2d92b4f1140bed3ca2f51"
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
