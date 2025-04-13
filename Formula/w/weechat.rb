class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://weechat.org/"
  url "https://weechat.org/files/src/weechat-4.6.1.tar.xz"
  sha256 "d4344bd816a7f1ddb21ea7fb8135af87bebbcbb9e1b8362cd7432901d1902065"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "2a8de3a2d45c3b08cb05f8edb35c36e63d18a6c0db24d655e7cffc74fc524b68"
    sha256 arm64_sonoma:  "e403f13cfa044fbc9160b8f0b11af49f15f274081cadafe206d2ebb75a3df61d"
    sha256 arm64_ventura: "6e9305083c2659ad4614f0fedeeb977d78bdb37c035ffcdc464b73db953a60d3"
    sha256 sonoma:        "763728d1d9c16998afab6a5dfd4821a743f8d54d8e0741632fb40b981bbf032c"
    sha256 ventura:       "1ef9e095ff2f44b8a1a549b0fa2b8db86fb54d7924e8cc35b1b0967ab860a67b"
    sha256 arm64_linux:   "c0c473bc8c8e9a2a473fc26ac2c188de5a3cd367c20976837dbc9a52fa7be5ad"
    sha256 x86_64_linux:  "5286ae40440235e5876c27f120283475607334dc786f9647496d259ff1701cd0"
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
  depends_on "python@3.13"
  depends_on "ruby"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "libgpg-error"
  end

  def python3
    which("python3.13")
  end

  def install
    pyver = Language::Python.major_minor_version python3
    # Help pkgconf find python as we only provide `python3-embed` for aliased python formula
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
