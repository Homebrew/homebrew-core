class YamlCpp < Formula
  desc "C++ YAML parser and emitter for YAML 1.2 spec"
  homepage "https://github.com/jbeder/yaml-cpp"
  url "https://github.com/jbeder/yaml-cpp/archive/yaml-cpp-0.6.1.tar.gz"
  sha256 "25ec37e6d82ab8c485926d69a5567741c7263515f8631e5dcb3fb4708e6b0d0d"

  bottle do
    cellar :any
    sha256 "6d6b306fb32395ca6555eb493a95083f9d6b8dfb0ec98d246248132cef60236e" => :high_sierra
    sha256 "9fb76cf549256913c312ba9647614aa52d28e15cb759ed25706011cbdadd2fe0" => :sierra
    sha256 "7ef12efa1b564abc652243f146f7f9b5b8d51f8600917743ab8c8bacfcdbd053" => :el_capitan
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
