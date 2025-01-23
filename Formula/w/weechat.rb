class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://weechat.org/"
  url "https://weechat.org/files/src/weechat-4.5.1.tar.xz"
  sha256 "67c143c7bc70e689b9ea86df674c9a9ff3cf44ccc9cdff21be6a561d5eafc528"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "1d67c5430fb275208b17667d4d46efb27f73407d16b74b87450e21f6da71b990"
    sha256 arm64_sonoma:  "eb160a670b4fe6283c27439b8ef204fd5cef1960657ab42f22d4b9deed6a3a35"
    sha256 arm64_ventura: "ec8f40a100219d9e16f3ec871a8df4be7516318c85b99c7edaacc0be8993f8b5"
    sha256 sonoma:        "4bb5fba2ce14d53c8a7be428c86bfff71628f56413fa3110cf0937e8ba24ccb4"
    sha256 ventura:       "0fef6a116c728fc85aed039a03fb8ae0e9b850cb8156e689f3f63d26dc6ae803"
    sha256 x86_64_linux:  "22e73215745c6ca186413a0b85847bffbc1d744090e2a5542afbb129b9e2fb24"
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
