class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-4.4.2.tar.xz"
  sha256 "d4df289a9c5bca03a6d4fae006e52037064ef03bad6fbe959c538f3197434dec"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "59b7d3d1a8900eb7c54fa3af1d910d785522b8f44f879f60f471487cb02ad8e7"
    sha256 arm64_sonoma:   "8b2326d89cfb45906289381d0440039eeece9ce996c88dbfdb271f199fd752b0"
    sha256 arm64_ventura:  "8897abfb4a5567410a876a2f661fbe5747e67e96996a9ab3a927163cd90e103d"
    sha256 arm64_monterey: "f54d97be128b34685f140996669e758f0ef6332a4742955cac60e9120335587d"
    sha256 sonoma:         "12c45e6aba2f0dd1e2a9a6af2f4486daa485c64f4c0104c8f5b8385bd33ac0fd"
    sha256 ventura:        "698d4fe40ecdee37e0b7b2a331fd3895dc88de73d04220d739a74733bb596187"
    sha256 monterey:       "7a8179859ad4c5bcce022a329686e74303863eb85410f5254245ec023ed7cd8a"
    sha256 x86_64_linux:   "419c4c2b37a67f69a96924bb73d2b5b4caf0ffbccf672fa5062a593572fb3b9b"
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
