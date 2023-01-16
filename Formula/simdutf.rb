class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "cc23b47fd0caf9018fc0dcf49ebeff2676654fff997f9f6ce50fa93cd36f661f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "86ce9419ccc2c5bce9bff79ff740f2adf46c7662416ea155509fcc024bb52d01"
    sha256 cellar: :any, arm64_monterey: "e234767794268fff49cfab7ce233e3fdafb854d0984e00405ecb9fda36a27a86"
    sha256 cellar: :any, arm64_big_sur:  "3e7f10b7cfcf220fbfbab8997a79c27f21d06cc4afa26230ee1854e034a15fc0"
    sha256 cellar: :any, ventura:        "aac7ce65ccb3d1b86f750c70ab45f0f0a593fc0273ae599463c90a62a4be9a62"
    sha256 cellar: :any, monterey:       "45e5c0d535a99b57fcb9cbdb3947e92e8b17d5273d8546acb230035516de1086"
    sha256 cellar: :any, big_sur:        "801ac7c933d02abe711e7012973c2db8ad0d2db1bf69a0a74fbf7f86a822470e"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build
  depends_on "icu4c"
  depends_on "libiconv"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_TESTING=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install "build/benchmarks/benchmark" => "sutf-benchmark"
  end

  test do
    system bin/"sutf-benchmark", "--random-utf8", "1024", "-I", "20"
  end
end
