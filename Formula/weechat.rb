class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-2.8.tar.xz"
  sha256 "553ea295edad3b03cf88e6029c21e7bde32ff1cc026d35386ba9da3e56a6018c"
  revision 3
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 "ecc34bd5718199ec660b75f52b41541683135e25cb4fb68cb47f24947fd10f6c" => :catalina
    sha256 "a7e3192548d50da9329a201df5cfc88344867d2a72ad6883cee1ff56c4253283" => :mojave
    sha256 "05f72011278f099749983fd97b8829e74573c6ebcb62987ec35c1338f9b40fbc" => :high_sierra
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
  depends_on "python@3.8"
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
