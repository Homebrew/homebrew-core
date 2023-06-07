class YamlCpp < Formula
  desc "C++ YAML parser and emitter for YAML 1.2 spec"
  homepage "https://github.com/jbeder/yaml-cpp"
  url "https://github.com/jbeder/yaml-cpp/archive/yaml-cpp-0.7.0.tar.gz"
  sha256 "43e6a9fcb146ad871515f0d0873947e5d497a1c9c60c58cb102a97b47208b7c3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c0c34d815d25a11a6d2abcdd1d48491880a6c52ccb834517583d417be32da89d"
    sha256 cellar: :any,                 arm64_monterey: "870e42a85ee38ad3e908d2316f084ea62d01ee79aaa99975226457acdc0267df"
    sha256 cellar: :any,                 arm64_big_sur:  "73eb2c62c966671c744577b1ee6661edd0c1f993756ecdd68845aed7d67cc89a"
    sha256 cellar: :any,                 ventura:        "7d8e17b3f46aa111e1f911bdb16735d7199208299bb5c54d40f69434abf72b24"
    sha256 cellar: :any,                 monterey:       "352369aa5a46cbbc4f28296f51707ac0adfe30884a11d8b3e75b6a877d5f92e4"
    sha256 cellar: :any,                 big_sur:        "d78ff4565c1d214901754ec12f0e410d60c907a9a312ea246197bbf18fca4e8c"
    sha256 cellar: :any,                 catalina:       "7b8fb20fdf64723b7aa72127d070484ec9e3e3225c4ab5f3c6247743b987e9f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16923a628827f80bea57cad5c5a2ca222b2b00d0105367cb265f6c3df7f4b5c2"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args, "-DYAML_BUILD_SHARED_LIBS=ON",
                                          "-DYAML_CPP_BUILD_TESTS=OFF"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <yaml-cpp/yaml.h>
      int main() {
        YAML::Node node  = YAML::Load("[0, 0, 0]");
        node[0] = 1;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-lyaml-cpp", "-o", "test"
    system "./test"
  end
end
