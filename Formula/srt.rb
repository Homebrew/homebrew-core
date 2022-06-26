class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https://www.srtalliance.org/"
  url "https://github.com/Haivision/srt/archive/v1.5.0.tar.gz"
  sha256 "99e3625a6285b3b429af26abb1ec0a4bd0072db144bc4d617a83154d99a5dd1e"
  license "MPL-2.0"
  head "https://github.com/Haivision/srt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9e2a971ae1cb78832cd1e6cdb7ca0d4da5e75258c63e837f7f6191ba301cd537"
    sha256 cellar: :any,                 arm64_big_sur:  "76320349a7d9ddd3d7eca07a5b0100384bff76c1a15c51d35fe3093e908947ac"
    sha256 cellar: :any,                 monterey:       "27cd213ce6f1f10227d357371e6f254229a8617711703394f5e1cca02afff863"
    sha256 cellar: :any,                 big_sur:        "467748db3f76c9f98bc68bdb266f8d348716c5ae7029a7032a88b95094413077"
    sha256 cellar: :any,                 catalina:       "fa800cf09c2f68f6c6ecb8f37c8705e7b0cbc8243908317574558b689e585f33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6df02822d10c90b41a7be11c8286ab23738513776dc27e3395644cc1e2783168"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    openssl = Formula["openssl@1.1"]
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
