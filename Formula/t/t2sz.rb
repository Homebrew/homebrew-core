class T2sz < Formula
  desc "Compress a file into a seekable zstd with per-file seeking for tar archives"
  homepage "https://github.com/martinellimarco/t2sz"
  url "https://github.com/martinellimarco/t2sz/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "088b4cc1896f1c85c92db572f0ac170a9231492e244305754ca9bd5287faaa69"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cbda59b07b8a22b87d700be96de0c4a4ade591c808645432758a033be175694a"
    sha256 cellar: :any, arm64_tahoe:       "09ad7d5a2423360705f4d3b53991debd8b097ca206cc10b05fea1706b4902934"
    sha256 cellar: :any, arm64_sequoia:     "cbca3f8e2099017e0be6ad89bc991ca0396b7fdeca472f7012a50d7ed339d4a9"
    sha256 cellar: :any, arm64_linux:       "decf2a324270c8c207600aa653d4ac285c20d8c7b8120871b4c66ac5c6e07df5"
    sha256 cellar: :any, x86_64_linux:      "fb0ed2d80e2bf80b7f7e19a84f9eb1fb5c09daa9b9f6bdba6f77f5f5264a2d10"
  end

  depends_on "cmake" => :build
  depends_on "zstd"

  deny_network_access!

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
