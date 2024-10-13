class YamlCpp < Formula
  desc "C++ YAML parser and emitter for YAML 1.2 spec"
  homepage "https://github.com/jbeder/yaml-cpp"
  url "https://github.com/jbeder/yaml-cpp/archive/refs/tags/0.8.0.tar.gz"
  sha256 "fbe74bbdcee21d656715688706da3c8becfd946d92cd44705cc6098bb23b3a16"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b453cb98bf2c4dc253c3523f587a0af606e5a682bcd7b7bd0f69013e95cfe418"
    sha256 cellar: :any,                 arm64_sonoma:   "778720c980df7e2e5ed7a971eea721ecd6a21069f927279809496164c3248f69"
    sha256 cellar: :any,                 arm64_ventura:  "a257981f293174574400a08830c9edb3fef18a1d27d9c7a8f2a8ec0a6450a15f"
    sha256 cellar: :any,                 arm64_monterey: "5590ca844620d1eec096d947cd88d77acd0cec2094ea6558c56802f2960f3a80"
    sha256 cellar: :any,                 arm64_big_sur:  "2106ac96acedc1d4ee2d8e086b5408a8fc3cd67cea199234f91dcef2f1980fa3"
    sha256 cellar: :any,                 sonoma:         "2c0cc13d8e696a316db54c6d4ad4093c30c839c6677782968bcc59912207e1fd"
    sha256 cellar: :any,                 ventura:        "6df59a455c4312b58a636ea26c0f7b07a98e2718b7702f9c9a6603a3d18db540"
    sha256 cellar: :any,                 monterey:       "ed2271a45db27da472a35762a95ec0e36ee8be8a193593637b289eaa40d34e68"
    sha256 cellar: :any,                 big_sur:        "34e2ea6e7e4c5db76bdbe1eb799025c0143c3cda82ad561bf6354ba79e014427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eea8c23888c9026a8994e5b7b3b62e65b89da4d08db764c340900ecbe190f36d"
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
