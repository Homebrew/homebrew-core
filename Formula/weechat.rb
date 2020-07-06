class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-2.8.tar.xz"
  sha256 "553ea295edad3b03cf88e6029c21e7bde32ff1cc026d35386ba9da3e56a6018c"
  license "GPL-3.0"
  revision 5
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 "7ed7a9b41fc85455fd858d42f92055d72df8a67fef28ffda7eb5a12bb6dea890" => :catalina
    sha256 "b073952ee52a2bd0aea1fdc0520ca693be05e0e9aa031b254cd1fe95665b8787" => :mojave
    sha256 "454c8b6cff73afd673fc4ad5626ea1bc740b4f4aefeb8c860ebe5c09028854b6" => :high_sierra
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
