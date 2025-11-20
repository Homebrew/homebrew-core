class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://weechat.org/"
  url "https://weechat.org/files/src/weechat-4.7.1.tar.xz"
  sha256 "e83fb71ca251c5dd74bd9c5a6bd3f85dc2eb8ecec0955f43c07f3e0911edb7d3"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "main"

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "fe6fb4efbc0764836f935f9674f3862680b2bd12f6bace6ee4e30b3194f208c8"
    sha256 arm64_sequoia: "18bca2597fe1656b6ce052100e48aa8d1407639d3929be7abf0c71660e0741a3"
    sha256 arm64_sonoma:  "cba7ea407e89e6bb935dd5f10b07effc98a5e5ebff117e4ea04b8295c3b9bc3e"
    sha256 sonoma:        "9cd8969995a1431bf6a5ca25a1e8650ba78d14fe166f65edc78b80a3a622df04"
    sha256 arm64_linux:   "daf430902f3c7a1a46696f127fb36330b64cf628fdf40a049d1811607d12af31"
    sha256 x86_64_linux:  "8e0eae0c7cddd2d0080d4e8606b03f326df81b323221721b2f149604dc0fe39b"
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
