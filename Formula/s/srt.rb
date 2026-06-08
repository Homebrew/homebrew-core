class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https://www.srtalliance.org/"
  url "https://github.com/Haivision/srt/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "c3518bc43a71b5289032395b2db4c3e09e73d78b54247d56c14553a503b491cf"
  license "MPL-2.0"
  revision 1
  compatibility_version 1
  head "https://github.com/Haivision/srt.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c9efbdc89f5cdc3e9dbb553beb2d3715aa318f0dae16272e70eb1d5c317e32a9"
    sha256 cellar: :any,                 arm64_sequoia: "62d4e875692e2a09d5d82ebe3efc4bb6c0664df5255f532f19ade10724259079"
    sha256 cellar: :any,                 arm64_sonoma:  "c0efb2121ddc659a49371268e935c02b33db19d7d5084b30a9ebe246a096a485"
    sha256 cellar: :any,                 sonoma:        "64c0ace35271f71495a98eede14c90e6fb51a6e27c42db187cf7c50df7300bf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb0393ab5005b3222c168bb8f4cc605cf0c3959bdab3eb4f8fe5bb039695b3a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8149b38aef0937e3146f89666ea90bdd77575a6fcc84169ff7f00163559f9c33"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

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
