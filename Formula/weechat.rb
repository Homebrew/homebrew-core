class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-3.8.tar.xz"
  sha256 "f7cb65c200f8c090c56f2cf98c0b184051e516e5f7099a4308cacf86f174bf28"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "88a3f7fe6c40a891c1be89527f5020792825ffdc24d6507382f3fe1bff431aca"
    sha256 arm64_monterey: "06e08f1ad27dfec1e0f696aeb5f8f2023b94ab615b738b224691319ab2d17893"
    sha256 arm64_big_sur:  "998c2373d4655fb65d12866d3fc66243b353a7666b7e098f058053e0ae5f6352"
    sha256 ventura:        "a12953c8321ffe668f2fbc386f087c25d0a64ae477c4d57c8a8fc428cdaf4f16"
    sha256 monterey:       "7ccda4f0855c9815c75bda71f36a71811fdddf6a284db2740945b6b5e0358f9a"
    sha256 big_sur:        "60da359c99aa6addded807268491c2f418dfdcfce276eaeb7d963f4f8517f397"
    sha256 x86_64_linux:   "084cc8d8a91d8b1cdb387d7ae09c3e4a625909246d4fe9f67b056ed3d1ff84d4"
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
  depends_on "python@3.11"
  depends_on "ruby"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "tcl-tk"

  def install
    python3 = "python3.11"
    pyver = Language::Python.major_minor_version python3
    # Help pkg-config find python as we only provide `python3-embed` for aliased python formula
    inreplace "cmake/FindPython.cmake", " python3-embed ", " python-#{pyver}-embed "

    args = %W[
      -DENABLE_MAN=ON
      -DENABLE_GUILE=OFF
      -DCA_FILE=#{Formula["gnutls"].pkgetc}/cert.pem
      -DENABLE_JAVASCRIPT=OFF
      -DENABLE_PHP=OFF
    ]

    # Fix system gem on Mojave
    ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/weechat", "-r", "/quit"
  end
end
