class Zchunk < Formula
  desc "Compressed file format for efficient deltas"
  homepage "https://github.com/zchunk/zchunk"
  url "https://github.com/zchunk/zchunk/archive/refs/tags/1.5.5.tar.gz"
  sha256 "2ab8ef54475aa2b2c0120fc6ae6d0788e0c3d4d4b671985edc6a19c8096a02cc"
  license "BSD-2-Clause"
  head "https://github.com/zchunk/zchunk.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "aa6c207ed017c10456cf2f9508c53c0ecd0b9ab6c97a40614e0491f9a757c2da"
    sha256 cellar: :any, arm64_tahoe:       "b030a00b404781aaa84a6ac6b7e6feb3509320ef32888f765f778afb194449de"
    sha256 cellar: :any, arm64_sequoia:     "e20c02455b87833c1487901e044f91b11ccfc7bfe98d92a7f9d9c9a4be8d7401"
    sha256 cellar: :any, arm64_linux:       "a0742ee145330fb71578253d572c54207291a73038eef4714e2e1998f7883391"
    sha256 cellar: :any, x86_64_linux:      "e94ed931d69a35816530b90350f363e8d3e9ef86b685d7a133649063962e4b13"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"
  depends_on "zstd"

  uses_from_macos "curl"

  on_macos do
    depends_on "argp-standalone" => :build
  end

  deny_network_access!

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"zck", test_fixtures("test.png")
    system bin/"unzck", testpath/"test.png.zck"
    assert_equal test_fixtures("test.png").read, (testpath/"test.png").read
  end
end
