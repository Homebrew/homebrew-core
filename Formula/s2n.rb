class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/awslabs/s2n"
  url "https://github.com/awslabs/s2n/archive/v0.10.0.tar.gz"
  sha256 "ace34f0546f50551ee2124d25f8de3b7b435ddb1b4fbf640ea0dcb0f1c677451"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "563c56399c77a3d3a6a7fa265a854c11671e671ad679316e0f5eb3fadfe1d3ea" => :catalina
    sha256 "5dfe9d90d210cf4df21c785d866efb35a4e2a2c23fc79e8de2c77d732ae666c7" => :mojave
    sha256 "fa1f38966a646891d5fda5573743d5212f462a3d816e7879c92e27ef243858e8" => :high_sierra
  end

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
