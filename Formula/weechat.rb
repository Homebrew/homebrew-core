class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-3.0.tar.xz"
  sha256 "6cb7d25a363b66b835f1b9f29f3580d6f09ac7d38505b46a62c178b618d9f1fb"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 "31d5ae230f116f32ce02b0696c270cca9cdb4f0d0a76f1c1a43e7ec097eae77a" => :big_sur
    sha256 "5fd377992e946c4fd641b02a4d5f8d097e795f187997e7cebec519ed228ae72c" => :catalina
    sha256 "0357cae0f0b8df5ec39f981d1b8c7aa47912bd4b9f659dbf004683e9592b97da" => :mojave
    sha256 "d6b2d901b348e487720f0a6b08a6714c7489a6a454f45e9f5006f8508a1be66b" => :high_sierra
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
  depends_on "python@3.9"
  depends_on "ruby"

  uses_from_macos "curl"
  uses_from_macos "tcl-tk"

  def install
    args = std_cmake_args + %W[
      -DENABLE_MAN=ON
      -DENABLE_GUILE=OFF
      -DCA_FILE=#{Formula["gnutls"].pkgetc}/cert.pem
      -DENABLE_JAVASCRIPT=OFF
      -DENABLE_PHP=OFF
    ]

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
