class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https://www.srtalliance.org/"
  url "https://github.com/Haivision/srt/archive/refs/tags/v1.5.7.tar.gz"
  sha256 "017cd1e437ef2073a4dd10ddf7b55e86bc3d6ebac0393d13bd22f6a57055d32b"
  license "MPL-2.0"
  revision 1
  compatibility_version 1
  head "https://github.com/Haivision/srt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6d0783ae84caebbe1c8bd9204bf782b09c6a9cd1ecd579285b8ba2f39cf0d256"
    sha256 cellar: :any, arm64_tahoe:       "def16cad7b4d1d7a2e498b9e46e59798612130e9170af096e60ee9e642737e24"
    sha256 cellar: :any, arm64_sequoia:     "49961e6bb35fb555930142ccea104dacd22cc0d4de367741f6539ebe83a3624b"
    sha256 cellar: :any, arm64_linux:       "2b49c5c88630415a538bc72d2a3c532970211cd6e194a838c523247b8b1705bd"
    sha256 cellar: :any, x86_64_linux:      "5b4afd851b7cf690f24abcf4fe36237492351f35ae8a23d1660c73a91477e822"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  deny_network_access!

  def install
    openssl = Formula["openssl@4"]

    args = %W[
      -DWITH_OPENSSL_INCLUDEDIR=#{openssl.opt_include}
      -DWITH_OPENSSL_LIBDIR=#{openssl.opt_lib}
      -DCMAKE_INSTALL_BINDIR=bin
      -DCMAKE_INSTALL_LIBDIR=lib
      -DCMAKE_INSTALL_INCLUDEDIR=include
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cmd = "#{bin}/srt-live-transmit file:///dev/null file://con/ 2>&1"
    assert_match "Unsupported source type", shell_output(cmd, 1)
  end
end
