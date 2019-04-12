class Serial < Formula
  desc "Cross-platform, Serial Port library written in C++"
  homepage "https://gitlab.com/johnbarton/serial"
  url "https://gitlab.com/johnbarton/serial/-/archive/1.3.2/serial-1.3.2.tar.gz"
  sha256 "381ed4e4b76b414232b89ae044e3d6c1b6c2e2c99fdbea2625ce9888089fee72"
  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <serial/serial.h>
      int main(int argc, char **argv) {
        auto port = new serial::Serial();
        delete(port);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.c", "-L#{lib}", "-lserial", "-o", "test"
    system "./test"
  end
end
