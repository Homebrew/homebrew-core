class Wiiuse < Formula
  desc "Connect Nintendo Wii Remotes"
  homepage "https://github.com/wiiuse/wiiuse"
  url "https://github.com/wiiuse/wiiuse/archive/0.15.5.tar.gz"
  sha256 "d22b66eb13b92513c7736cc5e867fed40b25a0e398a70aa059711fc4f4769363"
  license "GPL-3.0"

  bottle do
    cellar :any
    sha256 "0a7689f0a9a9ad3fcfe44b35b3467f48c6065345ef8396c178fe0c3fcc22c7ff" => :catalina
    sha256 "2cd562e7ccdfa82c47a464b4a501925398ce8381e3489db0d7e773e8e2040002" => :mojave
    sha256 "40f7508add9a2974c76bd91d9e8fbe62bd2500ae4433de06af5711d340297b96" => :high_sierra
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
