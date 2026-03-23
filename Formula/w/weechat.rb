class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://weechat.org/"
  url "https://weechat.org/files/src/weechat-4.8.2.tar.xz"
  sha256 "7e2f619d4dcd28d9d86864763581a1b453499f8dd0652af863b54045a8964d6c"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "main"

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "6c54eb0323414f6cffc92dee72eee51b25d748747298ec2f1d451393d7888c49"
    sha256 arm64_sequoia: "116ac23fe6e3f3f74b1d8236b9be73294f73421aea4175110b9a69251456a5f4"
    sha256 arm64_sonoma:  "40cc10aa0c20c2490d66d5040a6c3e4f0190e0b38cf538f88cdd78921403f0ae"
    sha256 sonoma:        "7f80e8578ad21f50127e991556392b8f300a063e6a508e00a5b670d1c055eab1"
    sha256 arm64_linux:   "cbfd2a909f72770e8aa95315d37fb4b1e0c8911e4b1ecc8bfba92430217889ce"
    sha256 x86_64_linux:  "2bc33dc30ba07196534b3db48bfc655404da909a733c309a493c600d3b5c86bb"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "gettext" => :build # for xgettext
  depends_on "pkgconf" => :build
  depends_on "cjson"
  depends_on "enchant"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "python@3.14"
  depends_on "ruby"
  depends_on "tcl-tk"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "perl"

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
      -DENABLE_ENCHANT=ON
      -DENABLE_GUILE=OFF
      -DENABLE_JAVASCRIPT=OFF
      -DENABLE_MAN=ON
      -DENABLE_PHP=OFF
      -DTCL_INCLUDE_PATH=#{tcltk.opt_include}/tcl-tk
      -DTCL_LIBRARY=#{tcltk.opt_lib/shared_library("libtcl#{tcltk.version.major_minor}")}
      -DTK_INCLUDE_PATH=#{tcltk.opt_include}/tcl-tk
      -DTK_LIBRARY=#{tcltk.opt_lib/shared_library("libtcl#{tcltk.version.major}tk#{tcltk.version.major_minor}")}
    ]

    # Help CMake find Perl header on macOS due to non-standard layout
    if OS.mac?
      perl = DevelopmentTools.locate("perl")
      perl_archlib = Utils.safe_popen_read(perl.to_s, "-MConfig", "-e", "print $Config{archlib}")
      args += %W[
        -DPERL_EXECUTABLE=#{perl}
        -DPERL_INCLUDE_PATH=#{MacOS.sdk_path}/#{perl_archlib}/CORE
      ]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"weechat", "-r", "/quit"
  end
end
