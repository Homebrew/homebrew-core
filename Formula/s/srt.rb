class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https://www.srtalliance.org/"
  url "https://github.com/Haivision/srt/archive/refs/tags/v1.5.6.tar.gz"
  sha256 "2c4980c2c4cfd142d21b829d939dc51db9c6628af5967fff62fd7290769569c7"
  license "MPL-2.0"
  compatibility_version 1
  head "https://github.com/Haivision/srt.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9d74d2ad5d5377fca06ba458bf893b957012c32843f691354235101e6bfde10d"
    sha256 cellar: :any, arm64_sequoia: "98410b03733e805d67fce4806c563456cdb35261e1a9e5affecc4996b806239e"
    sha256 cellar: :any, arm64_sonoma:  "7b9db995a85bed7f2b45e538c1e5c440c63209ee1c4c814947a8d86a5b1b6b15"
    sha256 cellar: :any, sonoma:        "38ee84840c841b2686f9418bed76f6c60ac8b6eac31e7bba7d77d6673ad55e02"
    sha256 cellar: :any, arm64_linux:   "901eb8a08c683279e6209c2610352f1a9a9b35ace726b89b18b0d0f0654c8c71"
    sha256 cellar: :any, x86_64_linux:  "3a016c6489eff303d4444117ea11547abd8da90e4a714cdbccb9aa45939ba92c"
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
