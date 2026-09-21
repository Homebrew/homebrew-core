class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https://www.srtalliance.org/"
  url "https://github.com/Haivision/srt/archive/refs/tags/v1.5.7.tar.gz"
  sha256 "017cd1e437ef2073a4dd10ddf7b55e86bc3d6ebac0393d13bd22f6a57055d32b"
  license "MPL-2.0"
  compatibility_version 1
  head "https://github.com/Haivision/srt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1497982810a8dd675343c13cb3c2090fc8ed802d3d5d9223ff3019f737a162cf"
    sha256 cellar: :any, arm64_tahoe:       "a09e2746cd2fe48a6674da75c163705b91cb695ce2a585f5e62129dbe4f562d8"
    sha256 cellar: :any, arm64_sequoia:     "004246e6dd17bf156b3eae6f2b8cf6dd3575be4f310b7b532556bd6464d1f954"
    sha256 cellar: :any, arm64_sonoma:      "d860b499a28f363ac7a91fc80046966df861596e94e65d9edc3931f0268ca3a4"
    sha256 cellar: :any, sonoma:            "696700645531b6c3de17970c5f89e7c5f8925712bcff905dc8521c8bf0a95ab0"
    sha256 cellar: :any, arm64_linux:       "bcda48e594414b3d10ccd84b3e03f78797d7c5583471738092fb0f3acc8d6004"
    sha256 cellar: :any, x86_64_linux:      "c49b5154b38cc76ce246618290157675fa7ff263ae909417b6b770b981f0dc3a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  def install
    openssl = Formula["openssl@3"]

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
