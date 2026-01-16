class Zopfli < Formula
  desc "New zlib (gzip, deflate) compatible compressor"
  homepage "https://github.com/google/zopfli"
  url "https://github.com/google/zopfli/archive/refs/tags/zopfli-1.0.3.tar.gz"
  sha256 "e955a7739f71af37ef3349c4fa141c648e8775bceb2195be07e86f8e638814bd"
  license "Apache-2.0"
  revision 1
  head "https://github.com/google/zopfli.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "60d92c2dba51adbc2b158013f76e713caf79039176b8fce561d71e64eeb1ab1f"
    sha256 cellar: :any,                 arm64_sequoia: "05a753407e078eb62cc7763b8aadc6b5c239b961aa5208fa100ffcfacde1074d"
    sha256 cellar: :any,                 arm64_sonoma:  "abce2f037e1d3678b11116c779de02206b14d49da1388953414bd5f187ff1245"
    sha256 cellar: :any,                 sonoma:        "0f106e6ca21e768d2cee053ab91204dd59bdf02c2acfe94780d4f344dd32da9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73928042ea7ad2aeddbd734193759c045dd8320742be243256ccb12951daecdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66ed41c03d5bf67bc664988336d1cde7e330f24cd4b376eeaf1361a330ec02dd"
  end

  deprecate! date: "2025-11-13", because: :repo_archived

  depends_on "cmake" => :build

  # Backport fix for CMake 4 compatibility
  # PR ref: https://github.com/google/zopfli/pull/207
  patch do
    url "https://github.com/google/zopfli/commit/8ef44ffde0fd2bb2a658f75887e65b31c9e44985.patch?full_index=1"
    sha256 "4a6f0b3dc53ea6de1af245231b821a94389e91eab5bd3056f5735c3de29b0402"
  end

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
    system bin/"zopflipng", test_fixtures("test.png"), "#{testpath}/out.png"
    assert_path_exists testpath/"out.png"
  end
end
