class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-4.3.2.tar.xz"
  sha256 "e1f31de3dd3ee1989156f4c04e9f4bf6139da6ad50c24f691fc1057e4cfc37c6"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "6f57a88527f4554e8038339bef5c9fd865f5e2b28be7a6e8441206df37cbc4cc"
    sha256 arm64_ventura:  "d871c7911ed7dd6c613e1e26ed92e6a30904e791b19628985e818a3638918b16"
    sha256 arm64_monterey: "60536bf8ce49e56e50148f1f7a69b9f00f2edbe0467a7fe5fa1d14cc235438ec"
    sha256 sonoma:         "c34b1aa5cae4e1a5e26207792bb1b016442564c83f2a223808d47a53da410e42"
    sha256 ventura:        "c0137b3d7c4762ec8e203cb5c39425c29a602bafb42b7e4713b13650e1460bbc"
    sha256 monterey:       "5f5637902244e7b5d2c9187d6eb68973caf5351436c6f5557dc3be5beeb53163"
    sha256 x86_64_linux:   "4691a5b19b100696ae96a8a9d7c40b292ee580501aedc4418f73f9c8305c963e"
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
