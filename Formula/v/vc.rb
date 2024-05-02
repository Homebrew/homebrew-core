class Vc < Formula
  desc "SIMD Vector Classes for C++"
  homepage "https://github.com/VcDevel/Vc"
  url "https://github.com/VcDevel/Vc/archive/refs/tags/1.4.4.tar.gz"
  sha256 "5933108196be44c41613884cd56305df320263981fe6a49e648aebb3354d57f3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5293aa5119bd8b37b5d73d1944076534aae79d3d4436db82ff6bb130e8e7180e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "feba55569aead40c46d0a79e8ff8ba2c7f64679ddc6e2136258c53ba7e730b4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88935f1e7fc0564b58b03ebd4fef3244b2c540b96deff9700e44ca6c7630280f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b216a3d09bee77da164a475449cf0d9c84876ea1eece7ccf4d7c15966ccecaa"
    sha256 cellar: :any_skip_relocation, ventura:        "1069faf9f3a7c8121fc3f4cb0f62eace86cb3399d701a282b641ca9520c8c691"
    sha256 cellar: :any_skip_relocation, monterey:       "39570197fbc39087c9b46cfe533a74098d78f43aa6f8db7fa3a5a50679cfacc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c5b49f5a4c6bb2a291dcc8ccc374887bd53164fb4e1b530dee634c3b200fdf0"
  end

  depends_on "cmake" => :build

  def install
    ENV.runtime_cpu_detection
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <Vc/Vc>

      using Vc::float_v;
      using Vec3D = std::array<float_v, 3>;

      float_v scalar_product(Vec3D a, Vec3D b) {
        return a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
       }

       int main(){
         return 0;
       }
    EOS
    extra_flags = []
    extra_flags += ["-lm", "-lstdc++"] unless OS.mac?
    system ENV.cc, "test.cpp", "-std=c++11", "-L#{lib}", "-lVc", *extra_flags, "-o", "test"
    system "./test"
  end
end
