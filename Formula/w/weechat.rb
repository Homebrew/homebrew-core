class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-3.8.tar.xz"
  sha256 "f7cb65c200f8c090c56f2cf98c0b184051e516e5f7099a4308cacf86f174bf28"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "81dbe3808e48d498b71187fac4d3405957bdfdd1b01f2273b21c9f5b929947af"
    sha256 arm64_monterey: "951d48b9710833aad49e12e9d2a997a5a28eb130c5c80af02a8c36e905fb6a9c"
    sha256 arm64_big_sur:  "00ae684fae58358de7ed78b190287e6444915a314a95ed1b294a13afe0e14c24"
    sha256 ventura:        "fa0bde3a8c097ca235321e51acf6c506bd226fdad9c784a974ec94040429eaff"
    sha256 monterey:       "1b0516b0c52f70bd4643739a43b68eaa003e1e4e7f6f8e9cc6aeb75720f23c83"
    sha256 big_sur:        "1b6fb83746f34664b1e4a7fee449b0a564acba1e886dde587b40074722df9388"
    sha256 x86_64_linux:   "1a4c2fd9d2a1e4ba4bc5d083fcaa78cbe93a3e9dfbeb4356198fdc85db213794"
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

    # Fix system gem on Mojave
    ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/weechat", "-r", "/quit"
  end
end
