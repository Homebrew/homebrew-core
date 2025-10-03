class Vc < Formula
  desc "SIMD Vector Classes for C++"
  homepage "https://github.com/VcDevel/Vc"
  url "https://github.com/VcDevel/Vc/archive/refs/tags/1.4.5.tar.gz"
  sha256 "eb734ef4827933fcd67d4c74aef54211b841c350a867c681c73003eb6d511a48"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d53132f09cec1f76a87908c55b8483b14597f078a4f94e54fd9db46e2d3d3011"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "789847027f8d06a5d306ffcf999f7080b0e257e9e336b557b78beb70f1ac4c3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "12e14e942d2a5731d3887be279807412ce7f5a8aee97299db2e4f9bc7018d307"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc7cfc2f7ab132f3e877d9457d4683335ea23453934447352567e71e19812cf5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1112be197628e9954b83528bdac5ea8899bcac4957ae808ffebc47ec08bae054"
    sha256 cellar: :any_skip_relocation, sonoma:         "de1f4a4224f4cb2a9b8cccbcc8bff55f6b54cc060df433f265cb6268e13beece"
    sha256 cellar: :any_skip_relocation, ventura:        "b718e2c8384e24be4668186f14e6a05e025e9244888c91a88ff2c30d0dc6658e"
    sha256 cellar: :any_skip_relocation, monterey:       "6710920fa0199be3b39e5bb10c0ac93f57b322637eadd606d7e307b149c93b08"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7cebe6014bee0f108e6ca0d508c87907d81167b67c6561a9eab3a1ecf3254355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "885b412d8d27d60b3db7c1a9ee1c6b2a41034e08bafd030f5e363a6e1301e7eb"
  end

  depends_on "cmake" => :build

  def install
    ENV.runtime_cpu_detection
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <Vc/Vc>

      using Vc::float_v;
      using Vec3D = std::array<float_v, 3>;

      float_v scalar_product(Vec3D a, Vec3D b) {
        return a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
       }

       int main(){
         return 0;
       }
    CPP
    extra_flags = []
    extra_flags += ["-lm", "-lstdc++"] unless OS.mac?
    system ENV.cc, "test.cpp", "-std=c++11", "-L#{lib}", "-lVc", *extra_flags, "-o", "test"
    system "./test"
  end
end
