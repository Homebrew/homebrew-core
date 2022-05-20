class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-3.4.1.tar.xz"
  sha256 "7e088109ad5dfbcb08a9a6b1dd70ea8236093fed8a13ee9d9c98881d7b1aeae7"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "80198dbca583a06b20e581bd3022dadbb48ecc01d420c1a23d329b6458f358f9"
    sha256 arm64_big_sur:  "be85e5b0ec97d771835aeaf0aefc233b0a89f94db33e281e91c1af10aa2ce39f"
    sha256 monterey:       "61131cc1a0ab1267409212a5dbdda2071f215e8599dd41384602fafb0c13315d"
    sha256 big_sur:        "4095840ed9d5d2cbbeafee118df2c03f956bd9204db07ad3a9d19bca701ba717"
    sha256 catalina:       "c27e5bf2cf1a47d0e02db588011efc45b7bece44534b5fa7a97e74e74c27ac07"
    sha256 x86_64_linux:   "2fc84f3e078f687a06cd9100faaeb7eb95700834a0a8d55c26b33c08aa5d5ff4"
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
