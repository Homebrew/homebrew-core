class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-4.3.3.tar.xz"
  sha256 "5587db6cea33895bda101c46a6d09e9fc08e0fca76ff8ac3b144dab32b105ed8"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "b47ba00856c83b2d740376c8fdd83692b8c0cafe9d45f576de7bbd31c4b1241a"
    sha256 arm64_ventura:  "ddaa757e1e5f96ce83041ff81b995f058a0c8ab1f092c4a2cfba38a3e1e05df1"
    sha256 arm64_monterey: "5e6c33212264419b34cf0c32999d7f3bcca7f4d7e275e9c0b78e6a8df94107c8"
    sha256 sonoma:         "8c4d244fc82cb6ec1d5df7119c2f577fd074164dd9890103875ae8085e48fce9"
    sha256 ventura:        "67153ba9a0d367e067d93644968d5d189e55a70ab890c997137441ce8bbd1785"
    sha256 monterey:       "92fa472d2b676d2f040df8b7a42269fbb3f7c5ad2ade786bf398a6e50653b17a"
    sha256 x86_64_linux:   "d0c2294b898f9e6269ef64c5d9c5ad640a296a48a456f617c559fb13568cc1ec"
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
    system "#{bin}/weechat", "-r", "/quit"
  end
end
