class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-4.2.2.tar.xz"
  sha256 "20968b22c7f0f50df9cf6ff8598dd1bd017c5759b2c94593f5d9ed7b24ebb941"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "6a25e4faa83a58793ae52b2642634a9817cbadb07efab24c2fba3ae783a92f2a"
    sha256 arm64_ventura:  "045fa311a13d43c47c4dcf7b08f77b4a0fc77bb4357bfb6a0845cfa688af7748"
    sha256 arm64_monterey: "caef2e9324e76d6fbe1f30c60f1ec2df329c9e2173f4bfb773ec404aaea9539a"
    sha256 sonoma:         "87db1528bec965f7bc9dc3917f4c439016ed43ed19f7fbe6cd3e96f5b7933a8e"
    sha256 ventura:        "05266964237d2ee14c5f7e3d7931d93a2de97cd4414833b8ebd6772ed70a348c"
    sha256 monterey:       "1ed41d2b0e425e5251c10644871360a4a67ebeafc2ca6928d0eea3fbbe5e34ba"
    sha256 x86_64_linux:   "d886000cc69eed0bf0e3d363b328d64b2f056b9b392f344a108021a9dbe8e4ef"
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
