class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-4.2.1.tar.xz"
  sha256 "253ddf086f6c845031a2dd294b1552851d6b04cc08a2f9da4aedfb3e2f91bdcd"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "a343f863b3809ff11e15462e4f11ea084294877deb081de8f6d37148ba9e26df"
    sha256 arm64_ventura:  "ad7c830f427e19779df6ce4ecb2404b7f7387f0af89fbe77b4fe16a6cdc92544"
    sha256 arm64_monterey: "49b62e1205c2fbd09bf61a8c906593dc82deab6f509d28f1960314b857c8ef0f"
    sha256 sonoma:         "d0434e1f26477bc69fd6a78f6df9a3021b5a43822943a5df4e2d0df7ef9c959c"
    sha256 ventura:        "a90f0a23894891e4ec1c7a2632529f47f5916cb06e05efb5b87683647cef8f6c"
    sha256 monterey:       "592f51bcb0b2e7c61867401d0a1d5d089e2a16475e39faa682cfd493adba79bc"
    sha256 x86_64_linux:   "34b5363f0764d120c7becb3551f812c8f5d3fe01f5197414067a69aec099920c"
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
  depends_on "python@3.12"
  depends_on "ruby"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "tcl-tk"

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
    system "#{bin}/weechat", "-r", "/quit"
  end
end
