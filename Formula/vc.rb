class Vc < Formula
  desc "SIMD Vector Classes for C++"
  homepage "https://github.com/VcDevel/Vc"
  url "https://github.com/VcDevel/Vc/releases/download/1.4.1/Vc-1.4.1.tar.gz"
  sha256 "68e609a735326dc3625e98bd85258e1329fb2a26ce17f32c432723b750a4119f"
  license "BSD-3-Clause"

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_TESTING=OFF", *std_cmake_args
      system "make", "install"
    end
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
    system ENV.cc, "test.cpp", "-std=c++11", "-L#{lib}", "-lvc", "-o", "test"
    system "./test"
  end
end
