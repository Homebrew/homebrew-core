class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-4.1.0.tar.xz"
  sha256 "030482e5b8f0f69c6bfd4a636b6fa6d76b64a9ec1e179f1abaa35b1ab38d1e10"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "534fa4a88e5b2ddc3f8ad3cf21a119b52f696913774f12637b111c5d57207766"
    sha256 arm64_ventura:  "5a9514c69d4d1da13477794cb653edafbd109d12683751063ac7e37f0fce156d"
    sha256 arm64_monterey: "ed5547163a3603362a2095b71b852126ceb5d068f021a60ba547d5e5af6b9637"
    sha256 sonoma:         "08594e668004acfa661bdc2a02aefbf33cbd4a6b7dc098db99d06c96c8c30b7e"
    sha256 ventura:        "1d58cdb7311dce577cd7fea544a3650f8fc32143811ddbebf536f931d641af43"
    sha256 monterey:       "cf8876049d3a2b52e74e97a409b5905319e60c037a867660347f6e0856caad9a"
    sha256 x86_64_linux:   "3a47479f9d08259525c33880c4afe9d6fe9e7539ed775dd839bbd4cf9ed7144b"
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
