class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-4.4.0.tar.xz"
  sha256 "dc86018be989d7643da76b9c10fa2d5aac27073bf254d1aea97b0bbf6d557d65"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "0b03265a4b448dcb84923faa5752e655b676d1783d02e39043912757600b4441"
    sha256 arm64_ventura:  "7e45dd8d31c362ecec44e39c7257283df116227b6a0ad4201cee5f3c8e6eb840"
    sha256 arm64_monterey: "f8a0023db5253e6c83061ec4558801c5e1c2ee66e8e910f93393508888f85e4b"
    sha256 sonoma:         "877678d87a84f059c77557dd596e3252d4b166d6ac20e8557e400695f8791739"
    sha256 ventura:        "add56a7cc035f01099401ec6c94a17d73583c2becd10e32f64bdb851bade67aa"
    sha256 monterey:       "04086dd489a5425e7ab1c04c4b58cf22ddd0cc96b338a60f791b6aee53d40792"
    sha256 x86_64_linux:   "e31a07c918f728177424b633b25f4d0429d5c498fae6b56edbeff4c0378edd3d"
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
  depends_on "python@3.12"
  depends_on "ruby"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libgpg-error"
  end

  def python3
    which("python3.12")
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
