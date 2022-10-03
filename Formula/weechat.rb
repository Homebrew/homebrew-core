class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-3.6.tar.xz"
  sha256 "9d85d71b3b7d04c03bd35ab6501afa8b5b3c609dce7691709ec740fecc31f2de"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "941f887ca171df0883180955c609d25614e743ded5d81a5b9c71636c264f87cf"
    sha256 arm64_big_sur:  "6ee106d0aa6274414b860063378e2332f6aad6b30d1447d993eae862b767e8c7"
    sha256 monterey:       "05a280fda741e8848b66317de037931d574865844a42130ea2cbfdea35261cb8"
    sha256 big_sur:        "c109e4066db8ee4c6f5b322f83d463bbdd67a4cb5191d15884c462681dee2c6d"
    sha256 catalina:       "009fd5f1f4c56c18a87d3e623f0b25297c6b8c21b9505262ac8a019bae5d10c4"
    sha256 x86_64_linux:   "af6433a705cb652af9d7b5446991874312fb58fa9772a7d88d9bcfc3e452622c"
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
