class Sortmerna < Formula
  desc "Next-generation sequence filtering and alignment tool"
  homepage "https://sortmerna.readthedocs.io"
  url "https://github.com/sortmerna/sortmerna/archive/refs/tags/v4.3.7.tar.gz"
  sha256 "6b62def30704ea956e1de060b602f9bebc8f2ba68107c59329b332500997b1d2"
  license "LGPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "concurrentqueue" => :build
  depends_on "lz4"
  depends_on "rocksdb"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = %W[
      -DCMAKE_CXX_FLAGS=-I#{Formula["concurrentqueue"].opt_include}/concurrentqueue/moodycamel
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "data"
  end

  test do
    cp_r pkgshare/"data/.", testpath
    system bin/"sortmerna", "--ref", "test_ref.fasta", "--reads", "test_read.fasta"
    assert_path_exists "sortmerna/run"
  end
end
