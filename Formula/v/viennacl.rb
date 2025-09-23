class Viennacl < Formula
  desc "Linear algebra library for many-core architectures and multi-core CPUs"
  homepage "https://viennacl.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/viennacl/1.7.x/ViennaCL-1.7.1.tar.gz"
  sha256 "a596b77972ad3d2bab9d4e63200b171cd0e709fb3f0ceabcaf3668c87d3a238b"
  license "MIT"
  revision 1
  head "https://github.com/viennacl/viennacl-dev.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "ef65ab6738404defb457637aa1d644b54db8bd55b9c0ddcc99dfb005e2653441"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dd97554d6b9c07ca2fcf625dec5198ef86dffba1b1723e9e83796ccba63c2d7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0190d51c44ab429c844d6c7d74d85aaa447639e320ad460f491e5b5a6fff8f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a55d8851ffa58afce58203d6ed577321fa309f02c63f472794c35e147bbee696"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8088de8835167e42aa0271cd230cea442279337a2108576fd46a1db4610c72c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "194ed5f169b951284a52fd44858a435b4312abd99f420a9b963823a4736d66c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "8baf6eb07e9d6a0d8a302d5f0a406abeec1a734ead438b381e1a4b9343c06aba"
    sha256 cellar: :any_skip_relocation, ventura:        "39bb6f51bf36fed3df3de63ef1b2ab0c52b2d1ddf9bbded384d9f5fa2591d7d9"
    sha256 cellar: :any_skip_relocation, monterey:       "c727de7f290a066e697f0bdddc8fb72c544a725f8984872ecc87fe9a3127d377"
    sha256 cellar: :any_skip_relocation, big_sur:        "edf2e2951bd78f8677614eed708dc5aaf038c520cd270b4ff0ace91ec73b843d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8be9cf74c6fa495a1958540b784d738db97428ddfc84c582860ad952faa5162e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8386a723438da51b3051c19ecc14af8c69f27c6a17f6f7e6b1bdcec6c1c85083"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    libexec.install "build/examples/benchmarks/dense_blas-bench-cpu" => "test"
  end

  test do
    system opt_libexec/"test"
  end
end
