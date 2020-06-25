class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/awslabs/s2n"
  url "https://github.com/awslabs/s2n/archive/v0.10.0.tar.gz"
  sha256 "ace34f0546f50551ee2124d25f8de3b7b435ddb1b4fbf640ea0dcb0f1c677451"

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ls2n", "-o", "test"
    system "./test"
  end
end
