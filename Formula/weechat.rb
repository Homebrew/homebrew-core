class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-3.7.1.tar.xz"
  sha256 "c311c9de9f5d87404b667e0c690959388295485bce986fac4ab934ebd43589aa"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "01b097f108da34b615fbcf447a221f181e9f09edbfae51be6933bcaae2c52cdc"
    sha256 arm64_monterey: "eb85c23c42b7a2b0962c2926c55bce19ab33c1fec790428c52abf322e536763a"
    sha256 arm64_big_sur:  "9ac39226c800db6c682d7403a0d7ce160853a4338f39330546bd4963c2e40dde"
    sha256 ventura:        "b5c60e18b8466972748311c13b3c244230668018839e6f494719d4d2eb18f4ca"
    sha256 monterey:       "3371b53f6ad1a8893d4a433ce9f5a7bdd2bdda43d0dce816d5cf1cfd9b68e795"
    sha256 big_sur:        "bff8dcbe08c52b6da68f3f152d62f15864d0cba35cf57f65020c7c48c2eaea3b"
    sha256 catalina:       "86bcca70d770c16030cd51c842d0e470112ea71054ff0275d611402de32090f7"
    sha256 x86_64_linux:   "3aa301ebd122d1ab34c5f6d3864a94b694be257ca21b7999c2886fbba6aa6d19"
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
