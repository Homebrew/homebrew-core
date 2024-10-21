class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-4.4.2.tar.xz"
  sha256 "d4df289a9c5bca03a6d4fae006e52037064ef03bad6fbe959c538f3197434dec"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "414ec5dbac1074369636c3abf3f63bd55eebf2aaa27cc1da1843a30a83794f5e"
    sha256 arm64_sonoma:  "f3e1dc302a9662e1fb11ff5231a202a6b103fa682e35c758148d5450f1c4b564"
    sha256 arm64_ventura: "c06b518c8f0863961f92d9f534892fb8e2d011bea9f95509ced75b76211834ba"
    sha256 sonoma:        "b017f4c2c74e7d56dbe6c17e24bbe2d2d54b42bb0512e3ae5e1b86846d7683a1"
    sha256 ventura:       "01e96a9d1400742e0cd922c9cda4af40dc9bb35b5628057613f5e8bb0705dc03"
    sha256 x86_64_linux:  "bec747add7e5341a1f76711402538da57090812daad10276f7d745e6bf86bcb4"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "cjson"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python@3.13"
  depends_on "ruby"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libgpg-error"
  end

  def python3
    which("python3.13")
  end

  def install
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

    if OS.linux?
      args << "-DTCL_INCLUDE_PATH=#{Formula["tcl-tk"].opt_include}/tcl-tk"
      args << "-DTK_INCLUDE_PATH=#{Formula["tcl-tk"].opt_include}/tcl-tk"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"weechat", "-r", "/quit"
  end
end
