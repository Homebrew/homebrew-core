class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-3.7.1.tar.xz"
  sha256 "c311c9de9f5d87404b667e0c690959388295485bce986fac4ab934ebd43589aa"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    rebuild 2
    sha256 arm64_ventura:  "7e6a3c6240984ee418e232be90cd663119797e3a831bc175f3d3078b8f8835a7"
    sha256 arm64_monterey: "3c7ec077b0032959b68a2e65cf3760c4c4d1b36534fa585c3b3ba35d130ad846"
    sha256 arm64_big_sur:  "dacd747d7fc7a385df569a1041b08fe3bd564b1fb8aa23daac2a1dbe51434004"
    sha256 ventura:        "838e080cdb91c6fabe1ae9064f6a76af76b2062178b1c86367164bf683328229"
    sha256 monterey:       "65b27bd0faadb076b3553745d79bd16a7943be9cd690b19171f02d00cab63e35"
    sha256 big_sur:        "3c702ecd6c99d74d3d894b6c7dd7caaf168712d5fa6fe4449d5284b6eabaae70"
    sha256 x86_64_linux:   "910f20e9130def634c5ef9783618c21b03b1a5c3a5c0cc35d5a9c7a8bda4f2e4"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python@3.11"
  depends_on "ruby"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "tcl-tk"

  # Fix build with Ruby 3.2
  # https://github.com/weechat/weechat/pull/1865
  patch do
    url "https://github.com/weechat/weechat/commit/49ce7be88e331b4b23a2b918138e6238a998a2f8.patch?full_index=1"
    sha256 "14fce206fbda311e1e355e0d1504d347e801c92b4d1a3d30f564b8356b408ec5"
  end

  def install
    python3 = "python3.11"
    pyver = Language::Python.major_minor_version python3
    # Help pkg-config find python as we only provide `python3-embed` for aliased python formula
    inreplace "cmake/FindPython.cmake", " python3-embed ", " python-#{pyver}-embed "

    args = %W[
      -DENABLE_MAN=ON
      -DENABLE_GUILE=OFF
      -DCA_FILE=#{Formula["gnutls"].pkgetc}/cert.pem
      -DENABLE_JAVASCRIPT=OFF
      -DENABLE_PHP=OFF
    ]

    # Fix system gem on Mojave
    ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/weechat", "-r", "/quit"
  end
end
