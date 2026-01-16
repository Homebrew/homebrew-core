class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://weechat.org/"
  url "https://weechat.org/files/src/weechat-4.8.1.tar.xz"
  sha256 "e7ac1fbcc71458ed647aada8747990905cb5bfb93fd8ccccbc2a969673a4285a"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/weechat/weechat.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "a498e1e85892dbd99c4870bd339bc5f3cce3a21e72c5e25c6fe4cc5d9b28879c"
    sha256 arm64_sequoia: "4ddaf60ed9ecd5a76685d337f92bca8e77aa498c8e8556e6d5721a1d252ddf87"
    sha256 arm64_sonoma:  "4d76b7238e5cbb8b712ccac45a7ceef05a2cf1325e8fcc2a4df12a79c7958233"
    sha256 sonoma:        "8127910e73551961779462f914c9abbb098af83e72ab4799addf398f8455bce1"
    sha256 arm64_linux:   "7273a5092bf8bc89bdc9c3841a1588860ea49033d6a91d7ec2dd72c942d46e7e"
    sha256 x86_64_linux:  "48e8d6f0d7d4780a1a397d8e5c3bbdbe993d1388d446419079208d0e8b5c7dfa"
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
