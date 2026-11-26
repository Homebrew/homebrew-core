class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://weechat.org/"
  url "https://weechat.org/files/src/weechat-4.10.5.tar.xz"
  sha256 "1ad22c0ede147d952cf9eaa35a61c2327b05fb3d90b295234392559cb2f866ad"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "main"

  bottle do
    manifest_sha256 "9b13230f9527854b56605558bbc99296fdb0b9362b5e9e3d9531c0f60189d36d"
    sha256 arm64_golden_gate: "62bb323ebbcfb483544a00807bdbd1f997661101a864bc81050e8f29b0788a88"
    sha256 arm64_tahoe:       "9cfcef3d9e56c6a1da27cab152e1b90208b96e8689e245feaa1f4678bc88b9c5"
    sha256 arm64_sequoia:     "ea3537c8f9ec8b8b659d43f4b088e7d8ff343f52b72b0102b32944f6ba39471b"
    sha256 arm64_linux:       "f815d61cdc36096bf7276000e94f5b80664fba284475152938913f8c945b59ae"
    sha256 x86_64_linux:      "9d1aeb4dfda44bd50a460f970a5d041dcffa391efbf12a27f2475f267c2688fc"
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
  depends_on "python@3.15"
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
    tcltk = dep("tcl-tk").to_formula
    tcl_library = tcltk.opt_lib/shared_library("libtcl#{tcltk.version.major_minor}")
    tk_library = tcltk.opt_lib/shared_library("libtcl#{tcltk.version.major}tk#{tcltk.version.major_minor}")
    args = %W[
      -DENABLE_ENCHANT=ON
      -DENABLE_GUILE=OFF
      -DENABLE_JAVASCRIPT=OFF
      -DENABLE_MAN=ON
      -DENABLE_PHP=OFF
      -DTCL_INCLUDE_PATH=#{tcltk.opt_include}/tcl-tk
      -DTCL_LIBRARY=#{tcl_library}
      -DTK_INCLUDE_PATH=#{tcltk.opt_include}/tcl-tk
      -DTK_LIBRARY=#{tk_library}
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
