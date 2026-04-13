class YamlCpp < Formula
  desc "C++ YAML parser and emitter for YAML 1.2 spec"
  homepage "https://github.com/jbeder/yaml-cpp"
  url "https://github.com/jbeder/yaml-cpp/archive/refs/tags/yaml-cpp-0.9.0.tar.gz"
  sha256 "25cb043240f828a8c51beb830569634bc7ac603978e0f69d6b63558dadefd49a"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fd9acbbaebb15dfdb1096ccff63da963421908b3e2a7a0f28ad572f3c8cf467c"
    sha256 cellar: :any,                 arm64_sequoia: "404b99a2150c5d600ff6dfb683501a18257626a74b1a1ca53fdc8e0f63251c70"
    sha256 cellar: :any,                 arm64_sonoma:  "9a9bf6ea55bf92c9e6d3f0a6099d1833ee4dcbedb52e7a921f1aadc8ab82c19e"
    sha256 cellar: :any,                 sonoma:        "eeeb0bc382151f6813e25f5f497dd896d81c23166360db31f547548fb3983203"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c568377c54d3607fa4952edda7935da932bd26f43aab278661de1a0e716d6036"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef3da003a3b2fb74540f46d069481c79c80edd4bb21cf1d754d8bbf65ff2890a"
  end

  depends_on "cmake" => :build

  def install
    args = %w[-DYAML_BUILD_SHARED_LIBS=ON -DYAML_CPP_BUILD_TESTS=OFF]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <yaml-cpp/yaml.h>
      int main() {
        YAML::Node node  = YAML::Load("[0, 0, 0]");
        node[0] = 1;
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-lyaml-cpp", "-o", "test"
    system "./test"
  end
end
