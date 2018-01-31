class YamlCpp < Formula
  desc "C++ YAML parser and emitter for YAML 1.2 spec"
  homepage "https://github.com/jbeder/yaml-cpp"
  url "https://github.com/jbeder/yaml-cpp/archive/yaml-cpp-0.6.0.tar.gz"
  sha256 "e643119f1d629a77605f02096cc3ac211922d48e3db12249b06a3db810dd8756"

  bottle do
    cellar :any
    sha256 "f4e9ed4651906c28464baf45d3a460502a24b42add49b35e969141818348680c" => :high_sierra
    sha256 "fe1fca40afa3817fd44b1f3c4810dce9f4d20390522526e72d775b9336fc3c3a" => :sierra
    sha256 "20b38c2f7c47550b458cb5b6f054795d90f4955d2525656e6d713cdbe7d451b1" => :el_capitan
    sha256 "e0a51ff0b33568695412fe43cdc51b26642ae46dfb6dac56b813295057c91bb6" => :yosemite
    sha256 "c779f86632b38472e022ad91f0f5ddb0f399fd547d36cbc5494a76c0f6becd48" => :mavericks
  end

  option "with-static-lib", "Build a static library"

  depends_on "cmake" => :build

  needs :cxx11

  def install
    args = std_cmake_args
    if build.with? "static-lib"
      args << "-DBUILD_SHARED_LIBS=OFF"
    else
      args << "-DBUILD_SHARED_LIBS=ON"
    end

    system "cmake", ".", *args
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
