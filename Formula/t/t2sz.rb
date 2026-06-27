class T2sz < Formula
  desc "Compress a file into a seekable zstd with per-file seeking for tar archives"
  homepage "https://github.com/martinellimarco/t2sz"
  url "https://github.com/martinellimarco/t2sz/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "4bdc590a8a2085951cfbe83ef6ab22b5fd4723163662e1aae41260c0b5a49a01"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "05420c0e03856beefe62395c7987b98b1b2228159938eeaa12c3a6e472e7d1d8"
    sha256 cellar: :any,                 arm64_sequoia: "471548c4ef9f8df185d042683ebe7a053ca37207442a1f7f923f0e2f40631fae"
    sha256 cellar: :any,                 arm64_sonoma:  "0bd9e3cc02d9dde481284c82568e048d4940fb191b066dd6614432c2f4304664"
    sha256 cellar: :any,                 sonoma:        "1154d2bf99a158b7aac817bb9722b728c5f68accec8199a91c937726bf3a0ada"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa3fe7e04b3f79638369d6d385a7a0cafeb14ca8538bb84958db43ebb8d55e60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d62971fe1bfb3abc690548725312eb45bff0208046c6a736bd19830024c24af8"
  end

  depends_on "cmake" => :build
  depends_on "zstd"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/t2sz -V 2>&1")

    (testpath/"hello.txt").write "Hello, Homebrew!"
    system "tar", "cf", "test.tar", "-C", testpath, "hello.txt"
    system bin/"t2sz", "-o", "test.tar.zst", "test.tar"
    assert_path_exists testpath/"test.tar.zst"

    system "zstd", "-o", "test.restored.tar", "--decompress", "test.tar.zst"
    assert_equal (testpath/"test.tar").read, (testpath/"test.restored.tar").read
  end
end
