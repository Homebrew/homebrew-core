class YamlCpp < Formula
  desc "C++ YAML parser and emitter for YAML 1.2 spec"
  homepage "https://github.com/jbeder/yaml-cpp"
  url "https://github.com/jbeder/yaml-cpp/archive/refs/tags/0.8.0.tar.gz"
  sha256 "fbe74bbdcee21d656715688706da3c8becfd946d92cd44705cc6098bb23b3a16"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "2568a74c90066c521d45bfd6057d55e52a1cf170b87d24321ed39a91a8013c31"
    sha256 cellar: :any,                 arm64_sequoia:  "b453cb98bf2c4dc253c3523f587a0af606e5a682bcd7b7bd0f69013e95cfe418"
    sha256 cellar: :any,                 arm64_sonoma:   "778720c980df7e2e5ed7a971eea721ecd6a21069f927279809496164c3248f69"
    sha256 cellar: :any,                 arm64_ventura:  "a257981f293174574400a08830c9edb3fef18a1d27d9c7a8f2a8ec0a6450a15f"
    sha256 cellar: :any,                 arm64_monterey: "5590ca844620d1eec096d947cd88d77acd0cec2094ea6558c56802f2960f3a80"
    sha256 cellar: :any,                 arm64_big_sur:  "2106ac96acedc1d4ee2d8e086b5408a8fc3cd67cea199234f91dcef2f1980fa3"
    sha256 cellar: :any,                 sonoma:         "2c0cc13d8e696a316db54c6d4ad4093c30c839c6677782968bcc59912207e1fd"
    sha256 cellar: :any,                 ventura:        "6df59a455c4312b58a636ea26c0f7b07a98e2718b7702f9c9a6603a3d18db540"
    sha256 cellar: :any,                 monterey:       "ed2271a45db27da472a35762a95ec0e36ee8be8a193593637b289eaa40d34e68"
    sha256 cellar: :any,                 big_sur:        "34e2ea6e7e4c5db76bdbe1eb799025c0143c3cda82ad561bf6354ba79e014427"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "124cab38c648ba776e8ae2af5b978c3bb74bc0c938fd922f0bb24976781d79d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eea8c23888c9026a8994e5b7b3b62e65b89da4d08db764c340900ecbe190f36d"
  end

  depends_on "cmake" => :build

  # CMake 4 build patch, remove in next release
  # PR refs:
  # - https://github.com/jbeder/yaml-cpp/pull/1171
  # - https://github.com/jbeder/yaml-cpp/pull/1211
  # - https://github.com/jbeder/yaml-cpp/pull/1351
  patch do
    url "https://github.com/jbeder/yaml-cpp/commit/f878043f12a9434a2ef72de3992ec92e6845c889.patch?full_index=1"
    sha256 "4aa70d90cd971776b9082c08586384f53f290f58f1835a1d1a81df1e2c6754c7"
  end
  patch do
    url "https://github.com/jbeder/yaml-cpp/commit/c2680200486572baf8221ba052ef50b58ecd816e.patch?full_index=1"
    sha256 "61789d44d8d9395fa32d1c0ec10f67087450305f087a0403ab8ba78a5f792efa"
  end
  patch do
    url "https://github.com/jbeder/yaml-cpp/commit/c9371de7836d113c0b14bfa15ca70f00ebb3ac6f.patch?full_index=1"
    sha256 "43379ee0a8d9620524a6a7d34b098363e22e4152cc634e10d5ef2a175697ae72"
  end

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
