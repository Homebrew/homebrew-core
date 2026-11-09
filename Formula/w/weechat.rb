class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://weechat.org/"
  url "https://weechat.org/files/src/weechat-4.10.4.tar.xz"
  sha256 "9b67a869330f34498f08dcab49edc1c54e9a8af136188d30d5ed1fb8257106da"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "ae831085eb778d4fb3c9683757881b74392a51659111fd1c81c058a6773ffd75"
    sha256 arm64_tahoe:       "cbb64e32eb3bfb5299d4ce30ed373c87816a2a8790dd2f88d9ac9e1eaee7938c"
    sha256 arm64_sequoia:     "2ba44717793d0690a5acd8c2df837b6a15f3b36901df5d0000ef4c01a97351a6"
    sha256 arm64_linux:       "a9c7de2576cf1a14bcac3962b14f423afef56cdc0c6a8dede0c356a36be9c834"
    sha256 x86_64_linux:      "4d32a5c2ec7180bf3b79884e4c554b2c2b5332089f5ecad865be7691488f0a35"
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
    tcltk = deps.find { |dep| dep.name.match?(/^tcl-tk(@\d+(\.\d+)*)?$/) }.to_formula
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
