class T2sz < Formula
  desc "Compress a file into a seekable zstd with per-file seeking for tar archives"
  homepage "https://github.com/martinellimarco/t2sz"
  url "https://github.com/martinellimarco/t2sz/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "0a39a2644aa1bec84dd31491bdafc6f4b4f2d5c8187144ff3273ea7e69c382a7"
  license "GPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "zstd"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello.txt").write "Hello, Homebrew!"
    system "tar", "cf", "test.tar", "-C", testpath, "hello.txt"
    system bin/"t2sz", "-o", "test.tar.zst", "test.tar"
    assert_path_exists testpath/"test.tar.zst"
    system "zstd", "-d", "test.tar.zst", "-o", "test.restored.tar"
    assert_equal (testpath/"test.tar").read, (testpath/"test.restored.tar").read
  end
end
