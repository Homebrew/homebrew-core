class Rapidyaml < Formula
  desc "Library to parse and emit YAML, and do it fast"
  homepage "https://github.com/biojppm/rapidyaml"
  url "https://github.com/biojppm/rapidyaml/releases/download/v0.15.2/rapidyaml-0.15.2-src.tgz"
  sha256 "85e1428266978ca4b28a4103f047314ee534be17502b30f752e5df736fd60df6"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c8c035d8a97967e6485c6d0bace425dbc8ae7e0417cba81c0539150750586c3e"
    sha256 cellar: :any, arm64_sequoia: "79d3ce7defc0f2d304c15a4f00e7658718c4e4faa95e533d77fb13fbb06a0289"
    sha256 cellar: :any, arm64_sonoma:  "ecee6c7062f5d59471b88b8cef5a29ca6f21f5e66fbf6570fb08790eae5dd37d"
    sha256 cellar: :any, sonoma:        "d058d06e4d6a1daf963654b230fbbfe77b77e5a7558b36f6887b59f79589e603"
    sha256 cellar: :any, arm64_linux:   "cf1102ef15a01929463a2b6287da2766a8858debebf7a0fe6caaef514024fe85"
    sha256 cellar: :any, x86_64_linux:  "35d64047155fa07e299ad0adebc1828e1d18a4ad4218a217da326a774e178851"
  end

  depends_on "cmake" => :build

  conflicts_with "c4core", because: "both install `c4core` files `include/c4`"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <ryml.hpp>
      int main() {
        char yml_buf[] = "{foo: 1, bar: [2, 3], john: doe}";
        ryml::Tree tree = ryml::parse_in_place(yml_buf);
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{lib}", "-lryml", "-o", "test"
    system "./test"
  end
end
