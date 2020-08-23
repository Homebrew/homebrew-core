class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-2.9.tar.xz"
  sha256 "eab406c385c3a10d0107ddc3aac6596ae8c59af99e9158c6d769e90ec9adfa0e"
  license "GPL-3.0"
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 "27597527a70b72960498c972a98837be24b8b7e2751e6b9cdacaf436eacea671" => :catalina
    sha256 "cdd18f140fe07c6244beea285942e6e507dea191e55bda661dcff3b12ec5c46a" => :mojave
    sha256 "a6db2ccf286b42557ca86fed6927f87053ed9c083090bd8a25bfbc68e7fa63cd" => :high_sierra
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
