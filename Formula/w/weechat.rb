class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://weechat.org/"
  url "https://weechat.org/files/src/weechat-4.8.1.tar.xz"
  sha256 "e7ac1fbcc71458ed647aada8747990905cb5bfb93fd8ccccbc2a969673a4285a"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "e7bc2bc74b7fe6de227ed099d90c418d7ca41db6f247921cea135ca7ff2381d8"
    sha256 arm64_sequoia: "c3d2e48d03ba05d737ec1d5f9a19bfae50003b87a7b08885465006ec30149da0"
    sha256 arm64_sonoma:  "2d3d17dafb3fe3042369c18e2118ea7c4ef18c1ef441869bc23d63c12f71bcd7"
    sha256 sonoma:        "e74914edd5133eea79ccc02529728088b0a24c26551cd0f17fee18beb7c0b340"
    sha256 arm64_linux:   "d03e18f22d25a0a5a6ad1db03a80d16abfd3cf477fb84f13f3ff2db7bbbe1c4c"
    sha256 x86_64_linux:  "0f19937c698a89fb3edc6d96c519dc9bef1ffce03cbbbdf7f15a2756163cded3"
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
  depends_on "python@3.14"
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
