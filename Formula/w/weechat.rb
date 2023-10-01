class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-4.0.5.tar.xz"
  sha256 "3d72e61b05631dabdc283231768f938a85544b27e31fabfe13c57b4df5c5e3bb"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "99019aab9404ea45ee75d8472e67168d874d89feee5e536966ed6bec2094c11f"
    sha256 arm64_ventura:  "540b94c77f035c1a55594ea2acf13be1442d86ef28c729d3ff10385554adbca0"
    sha256 arm64_monterey: "1b24f2b1eadbef22c04035b0ca4d409776f210ea6f5231957c7c69de4c02b37f"
    sha256 arm64_big_sur:  "d907af243d7e57075022b192db1593a4a2307e8ab2656161c7baec109e17e290"
    sha256 sonoma:         "db28de54f99db5c41b98d86b739480e28945712efe7c698a1b73c8cef24c190d"
    sha256 ventura:        "aa7c1451dc7e6e93d649d730b73ee10ea6b265376d58a5b6df8ff0c98a2446f0"
    sha256 monterey:       "26aaf741cec1fe3c8f4c60beabe1fa4173e65f0168945fbd532ce7cfe8cd676f"
    sha256 big_sur:        "c5a73451c99ca5f1e8f214dedfe03c9d1ad53e3831f189c629ec96911e75e794"
    sha256 x86_64_linux:   "e96d226d1fb8ec6c0238020b7ac34b06c040d1a8e3f9774fa1de23ee88586487"
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

    if OS.linux?
      args << "-DTCL_INCLUDE_PATH=#{Formula["tcl-tk"].opt_include}/tcl-tk"
      args << "-DTK_INCLUDE_PATH=#{Formula["tcl-tk"].opt_include}/tcl-tk"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/weechat", "-r", "/quit"
  end
end
