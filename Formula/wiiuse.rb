class Wiiuse < Formula
  desc "Connect Nintendo Wii Remotes"
  homepage "https://github.com/wiiuse/wiiuse"
  url "https://github.com/wiiuse/wiiuse/archive/0.15.5.tar.gz"
  sha256 "d22b66eb13b92513c7736cc5e867fed40b25a0e398a70aa059711fc4f4769363"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "b461bed6e6dd3ff0d1cca716383ec8355ce802c29a15eb1a063f7592780f519a"
    sha256 cellar: :any, arm64_monterey: "ea877bb14b706754856ae4b7a2192bc15c3ff8036ad4953d626dbcbe67a763fb"
    sha256 cellar: :any, arm64_big_sur:  "10407776ee12bc410143a63ced0de46badb10b4f9bb4af8fdadeb2501bac8f38"
    sha256 cellar: :any, ventura:        "e401fed16b71c5bee6b5a4b29a469cc4d2b68c8707b8f7d16d13e1846b804eb4"
    sha256 cellar: :any, monterey:       "1b80ae72844ad7197be6cb903f8a001c88a02d9e235cc6f77c293acf6bd4c78c"
    sha256 cellar: :any, big_sur:        "3bba847f421a4b946c07adc4dbbf0862e46e6fdf9c8e779e07fa6afd1364394a"
    sha256 cellar: :any, catalina:       "0a7689f0a9a9ad3fcfe44b35b3467f48c6065345ef8396c178fe0c3fcc22c7ff"
    sha256 cellar: :any, mojave:         "2cd562e7ccdfa82c47a464b4a501925398ce8381e3489db0d7e773e8e2040002"
    sha256 cellar: :any, high_sierra:    "40f7508add9a2974c76bd91d9e8fbe62bd2500ae4433de06af5711d340297b96"
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args + %w[
      -DBUILD_EXAMPLE=NO
      -DBUILD_EXAMPLE_SDL=NO
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <wiiuse.h>
      int main()
      {
        int wiimoteCount = 1;
        wiimote** wiimotes = wiiuse_init(wiimoteCount);
        wiiuse_cleanup(wiimotes, wiimoteCount);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-l", "wiiuse", "-o", "test"
    system "./test"
  end
end
