class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://weechat.org/"
  url "https://weechat.org/files/src/weechat-4.10.3.tar.xz"
  sha256 "a5bf6d57fd8b45ac663b8cac6642ebe89dfa0365d2a00fdf3953f0e2d84dce29"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "4795b25ff7a7683b9ee8b9737f430ac0823fa57aedd6cc5519c9ed74bb9f3694"
    sha256 arm64_tahoe:       "f87c20db5c4d6e0d2be56bc291e0107b33c20a9b69a0510f368b75b882861953"
    sha256 arm64_sequoia:     "6dbd3dfd87177403d6444006c7297980721865d2b3b6d0bb3007ea86634a92d4"
    sha256 arm64_linux:       "15c883cf181283667296c2f07e539434dee072b07ef2bd0ed01902e8c7b277d1"
    sha256 x86_64_linux:      "51bd0eeeef69283a25683d806a07769619c67becae89e7a5d62403c4e03feb70"
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
