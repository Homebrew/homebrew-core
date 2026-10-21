class Zopfli < Formula
  desc "New zlib (gzip, deflate) compatible compressor"
  homepage "https://github.com/google/zopfli"
  url "https://github.com/google/zopfli/archive/refs/tags/zopfli-1.0.3.tar.gz"
  sha256 "e955a7739f71af37ef3349c4fa141c648e8775bceb2195be07e86f8e638814bd"
  license "Apache-2.0"
  revision 1
  head "https://github.com/google/zopfli.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "02117d2bae99aaab9586b5a3aa395993d6f0c65a31b4e289d240d32e2aeaba7e"
    sha256 cellar: :any, arm64_tahoe:       "3cf189287454c0abe8c1da5747609ebe859ba188a3b9763cb44dbb5f759d32ae"
    sha256 cellar: :any, arm64_sequoia:     "4fe7df0649344fda621be648ce9c9d93b9d82e3e590fb292c7b7db3c54c70585"
    sha256 cellar: :any, arm64_linux:       "7ca2a485245ef744247a319113e9d202f7adca1702a4f1a1b2bda367616055b0"
    sha256 cellar: :any, x86_64_linux:      "bec0c8be797f1b8d0530193dd4bb13e23620dbbcc5cf6c26a62ddbdecd271c6e"
  end

  depends_on "cmake" => :build

  # Fix for CMake 4 compatibility
  patch do
    url "https://github.com/google/zopfli/commit/8ef44ffde0fd2bb2a658f75887e65b31c9e44985.patch?full_index=1"
    sha256 "4a6f0b3dc53ea6de1af245231b821a94389e91eab5bd3056f5735c3de29b0402"
    type :unofficial
    resolves "https://github.com/google/zopfli/pull/207"
  end

  deny_network_access!

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"zopfli"
    system bin/"zopflipng", test_fixtures("test.png"), testpath/"out.png"
    assert_path_exists testpath/"out.png"
  end
end
