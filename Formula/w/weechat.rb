class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://weechat.org/"
  url "https://weechat.org/files/src/weechat-4.6.2.tar.xz"
  sha256 "0fa0242a18116fe27f746dbb822121805da6bb5dbd40750d42c63306e4896628"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "ef4df65a4d3c46b514c3f13fb8f0eb78c57cd4bb96bcb6afe96c6e5781ab0abf"
    sha256 arm64_sonoma:  "84007886ec2ea2f65a2b22be63148377af897248cb44110565703a39bf8d49b0"
    sha256 arm64_ventura: "c6bc888393c338fc39d35757ada5db5ce05acda05ecd5eca6ca30c4c2eecb784"
    sha256 sonoma:        "f9b3076d67c5d3e1c9fe97908bfb8d7d76cbf39e4492c51696ae9a3a65bc57cb"
    sha256 ventura:       "1c1966de42bbc6b25addaa387cc9c971d4b47cdc4d8f6d0d9a84bf23fceb78f9"
    sha256 arm64_linux:   "18e5288c19916e6823679a5d034bc32638c5fd7b0f6a6a1cf09ee0b0565175e9"
    sha256 x86_64_linux:  "996588573056267eb6081a1726a4de3d7b03c8016db925124f5e4f608d8ab472"
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
