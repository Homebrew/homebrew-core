class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-3.7.tar.xz"
  sha256 "6bd6962581331d31f4d4f8da489a1d0e8315038001bc00afcd306e58db0a0c54"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "e1a90e239cd0b824e891336ce763d796ceb83b004e911240343a24765ddc6998"
    sha256 arm64_big_sur:  "695aafdd1f978774aa9914a0254bdbb4bc9f4c345c736e5087b0a19217849cb0"
    sha256 monterey:       "bc63bc8a5983da082a1d975b2bf231a179ed63b00f5f8d796e5ebef0197066c6"
    sha256 big_sur:        "10a2392e2b8c38a251ccadb04f6df9a690cf9bf479cfca34d9cd993049460a14"
    sha256 catalina:       "8e678b6faf0b467921de469100c9f90be111dcf981e0d03d621671956e8ecf13"
    sha256 x86_64_linux:   "0aa955142ef3b206e276c7676b35405695b9c1200e4a71f0394a7a1e8e2d86f2"
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
  depends_on "zstd"

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
