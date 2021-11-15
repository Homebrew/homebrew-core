class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey PIV application"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-2.2.1.tar.gz"
  sha256 "b7ede4ddc3d6e31de67b2e2ddcd319b22b40cc2e0973b9866d052a754493b14e"
  license "BSD-2-Clause"

  livecheck do
    url "https://developers.yubico.com/yubico-piv-tool/Releases/"
    regex(/href=.*?yubico-piv-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ff0bf8e60dcc118a6af53c268b3657b45968146e0c0ec100e39c83aaf211d93b"
    sha256 cellar: :any,                 arm64_big_sur:  "010fd380069d1b30971f6dedc434ea2ab55a2db8b05ba0fcb74115b3e3b4a724"
    sha256 cellar: :any,                 monterey:       "973473705c16f890b8479f6b616f0cee718195ecd645c05b1c53a8721db0acbb"
    sha256 cellar: :any,                 big_sur:        "886605cf401ac43e73fc09d7c443977e3fef3bf49dbcc49a68638f43705ad151"
    sha256 cellar: :any,                 catalina:       "c5b6ce9eb6b9501d4dccff86ea593d6ff1451be89712dd01369eb3671ae7fcb8"
    sha256 cellar: :any,                 mojave:         "21e6bea1407cf476c02575caa150e233674abc27abaa5a52d41f97365eb49a41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04df6364c57b50081bf17a12b220fe46e8a6b73c428e83f085641f6d98d92628"
  end

  depends_on "check" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "help2man" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "check"
  depends_on "openssl@1.1"
  depends_on "pcsc-lite"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_C_FLAGS=-I#{Formula["pcsc-lite"].opt_include}/PCSC"
      system "make", "install"
    end
  end

  test do
    assert_match "yubico-piv-tool #{version}", shell_output("#{bin}/yubico-piv-tool --version")
  end
end
