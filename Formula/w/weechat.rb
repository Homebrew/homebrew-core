class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://weechat.org/"
  url "https://weechat.org/files/src/weechat-4.9.2.tar.xz"
  sha256 "d1389a9e521bda0c4ebfa108e2abf885ee6c5150c385299f5dca0181a43a0914"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "12e6897ca35a43d7ae58f25b0c7cedb3942f8420adbc623062bc42e2492c6b82"
    sha256 arm64_sequoia: "5f4f8763ccf5f3a2b3f8cb9b3adcc0231e3415edb2e3269918279ede696b0705"
    sha256 arm64_sonoma:  "3ea69cf37669d2a0227fd1a823bbe57fbf5d65ea840fadcf34ede982e097e86c"
    sha256 sonoma:        "5b1ccf107703193212c8861b8516f2df80329f06d88bb51e8797f99cecf27148"
    sha256 arm64_linux:   "65b7d2aacd7f31c9f0babd62e09c65fecaafeab94689840027f7af5fb9212b1f"
    sha256 x86_64_linux:  "b74f84b8f271c7eee50a3cb10fe1d039a83857bee7b67e117c9931b7e9b3da0d"
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
