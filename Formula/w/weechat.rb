class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://weechat.org/"
  url "https://weechat.org/files/src/weechat-4.8.1.tar.xz"
  sha256 "e7ac1fbcc71458ed647aada8747990905cb5bfb93fd8ccccbc2a969673a4285a"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/weechat/weechat.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "d0683ca04c89caa303bef48503a7c7acec3898c936c0cf9de48dc2936f9ef909"
    sha256 arm64_sequoia: "35ab8fb4e534f93b229b9eb61cc59a488eef9a2eea3c5488a5e0b7acb89cf689"
    sha256 arm64_sonoma:  "4ce5a3f966cb1efcbadfd14960ab6489b9fbe3c39c138a927bffcbcf218baf9c"
    sha256 sonoma:        "0aa208c3851943315bfea423b60e738818394516bdee306bebdff62240e3ec34"
    sha256 arm64_linux:   "3a2919734a10eaaecdb54f5738b2e7df7eef2344df13f655727b530d8ce518cd"
    sha256 x86_64_linux:  "541e292101eb800038ce65afcd0b319ce4c122f527f25268e43f2d949161b28b"
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

  on_macos do
    depends_on "gettext"
    depends_on "libgpg-error"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
