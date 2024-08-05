class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-4.3.5.tar.xz"
  sha256 "e6dbc4c832da5c5b85e496fefc15237fbbe2a8f7ba2fbe81ee071dc0c66b4be3"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "ab70eb9c68cba4494a9df1a94ab835a634e41f5e81851efde93ac27850beda04"
    sha256 arm64_ventura:  "80d8b850d77efeddd210c32023bed60e50e8a301f156e887e7e93ea0c5c7d6d4"
    sha256 arm64_monterey: "927cd5e5279204f34a1ccbdc10c93147c3a25dedea96fe47d1f813317b2015c2"
    sha256 sonoma:         "eb03de462230bc6fcec5b2ab9a180b78def0584760fed6fc1daeda6bd1f69ea7"
    sha256 ventura:        "b72899bbef5031af14573309dbc54b64ed48f4405b24fac1595bf6cc8dd7f472"
    sha256 monterey:       "eb892dfef7893fad909d6579889790b97ad4018f5d8b21320c7b96de0a054c4a"
    sha256 x86_64_linux:   "b43ee6aed5cad62a5660c6cd17171f960b43d8c72a73ff91a0757454b7479b79"
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
