class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https://www.srtalliance.org/"
  url "https://github.com/Haivision/srt/archive/v1.5.1.tar.gz"
  sha256 "af891e7a7ffab61aa76b296982038b3159da690f69ade7c119f445d924b3cf53"
  license "MPL-2.0"
  revision 1
  head "https://github.com/Haivision/srt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9367c165b0403c682e2114dbf9b69fdf73e9d0d45061fb38d9c60d6a7ad96259"
    sha256 cellar: :any,                 arm64_monterey: "5b0b6aaf8789bb3e186b44f5aa2c5f2b5dc21d81b3acabd736d7e8118f6c8698"
    sha256 cellar: :any,                 arm64_big_sur:  "9066cf26efb2a4fcbae35e469ba4a789409cc5cd82f380199ebc6bd8223abc63"
    sha256 cellar: :any,                 ventura:        "f97789806dce21536acc23a343a9ccb39153f2d5eb361b4f3dd14a3e00815af0"
    sha256 cellar: :any,                 monterey:       "b3cf9a1aef82edad275d1a4a86cf92e96cfc4015a43bb6cb0d11100935ea03fe"
    sha256 cellar: :any,                 big_sur:        "a553462e28ffb0869605ad62b07bab10d678d8b2e9d9ac7a5eda12eb47979ce8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5015b64dbcb9637df8ed9b000d44a65875b0b306e64f8743d46a5392f2525104"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  def install
    openssl = Formula["openssl@3"]
    system "cmake", ".", "-DWITH_OPENSSL_INCLUDEDIR=#{openssl.opt_include}",
                         "-DWITH_OPENSSL_LIBDIR=#{openssl.opt_lib}",
                         "-DCMAKE_INSTALL_BINDIR=bin",
                         "-DCMAKE_INSTALL_LIBDIR=lib",
                         "-DCMAKE_INSTALL_INCLUDEDIR=include",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    cmd = "#{bin}/srt-live-transmit file:///dev/null file://con/ 2>&1"
    assert_match "Unsupported source type", shell_output(cmd, 1)
  end
end
