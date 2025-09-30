class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://weechat.org/"
  url "https://weechat.org/files/src/weechat-4.7.1.tar.xz"
  sha256 "e83fb71ca251c5dd74bd9c5a6bd3f85dc2eb8ecec0955f43c07f3e0911edb7d3"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "3760a027b13f43e0000b45063464b4b7f738fc7f15c1718c3643c81233d1fc5d"
    sha256 arm64_sequoia: "49b2099f0a1e8a5e1e0956d2f12091b1795501ecaaf566c60434ea37f7af67d0"
    sha256 arm64_sonoma:  "f71b979b629e34ab7ed293804d603a38f1655684c74b8aacf7ee1db8f3e2ca14"
    sha256 arm64_ventura: "71284c1d91c338d6b7260c4f06357fe25da1422d4861a335a2238e1df9dd55ef"
    sha256 sonoma:        "6ff2ebd94b1c5bea8605da2365e9ff974daa36aad3e58146b43eb2c182f9e156"
    sha256 ventura:       "531a5daea68fdc0dd410737affe69b03642071f1ebfddea578018a0ac2d766aa"
    sha256 arm64_linux:   "49a72bb5ba4b5344db4c4cdabe7b4f15d5370a1e506481271065b26526e74bee"
    sha256 x86_64_linux:  "e69a378a9363872ac7f63fd65c909394493286ee770207741b86415352349ac8"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "gettext" => :build # for xgettext
  depends_on "pkgconf" => :build
  depends_on "aspell"
  depends_on "cjson"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python@3.13"
  depends_on "ruby"
  depends_on "tcl-tk"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "libgpg-error"
  end

  def install
    tcltk = Formula["tcl-tk"]
    args = %W[
      -DENABLE_MAN=ON
      -DENABLE_GUILE=OFF
      -DCA_FILE=#{Formula["gnutls"].pkgetc}/cert.pem
      -DENABLE_JAVASCRIPT=OFF
      -DENABLE_PHP=OFF
      -DTCL_INCLUDE_PATH=#{tcltk.opt_include}/tcl-tk
      -DTCL_LIBRARY=#{tcltk.opt_lib/shared_library("libtcl#{tcltk.version.major_minor}")}
      -DTK_INCLUDE_PATH=#{tcltk.opt_include}/tcl-tk
      -DTK_LIBRARY=#{tcltk.opt_lib/shared_library("libtcl#{tcltk.version.major}tk#{tcltk.version.major_minor}")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"weechat", "-r", "/quit"
  end
end
