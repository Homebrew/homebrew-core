class Vineyard < Formula
  include Language::Python::Virtualenv

  desc "In-memory immutable data manager. (Project under CNCF)"
  homepage "https://v6d.io"
  url "https://github.com/v6d-io/v6d/releases/download/v0.14.0/v6d-0.14.0.tar.gz"
  sha256 "2d4fd4b1b809b2ec1af8abc3bd1d474174b93c3f3d541be11c80234fea7e51f7"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "0be26253a47db55ddf78f68a8cb6e141a5209e4bd4835f7c5607ce07f4132660"
    sha256 arm64_monterey: "1a71c02acf4e71a49cd09e7d888ab024a1349f961935b658a085c78850bdf463"
    sha256 arm64_big_sur:  "f320cb7d1da0029c929d988eafc1a4fe445210fe2b5af1d7df9bd05c56a82d6a"
    sha256 ventura:        "2a4a226d541a15ebf0d603c5ff6c3e7abde30c01f76083a9c0fc9cee7aaeb52c"
    sha256 monterey:       "4b72065f7e86f10e7f056131d13c1d7ea0e5adcc74e73918e00a3312c5bcb932"
    sha256 big_sur:        "4367d3fdd7b2f7cd3dbe8f34f62c313bb838c37e442799133aaa079b4872ac5c"
    sha256 x86_64_linux:   "70654a2c8af7aa8b466abeee8353ee6cdff1781e6323430eed3455268894a329"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "python@3.11" => :build
  depends_on "apache-arrow"
  depends_on "boost"
  depends_on "etcd"
  depends_on "etcd-cpp-apiv3"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libgrape-lite"
  depends_on "open-mpi"
  depends_on "openssl@1.1"

  fails_with gcc: "5"

  def install
    python = "python3.11"
    # LLVM is keg-only.
    ENV.prepend_path "PYTHONPATH", Formula["llvm"].opt_prefix/Language::Python.site_packages(python)

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=14",
                    "-DCMAKE_CXX_STANDARD_REQUIRED=TRUE",
                    "-DPYTHON_EXECUTABLE=#{which(python)}",
                    "-DUSE_EXTERNAL_ETCD_LIBS=ON",
                    "-DBUILD_VINEYARD_TESTS=OFF",
                    "-DUSE_LIBUNWIND=OFF",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <memory>

      #include <vineyard/client/client.h>

      int main(int argc, char **argv) {
        vineyard::Client client;
        VINEYARD_CHECK_OK(client.Connect(argv[1]));

        std::shared_ptr<vineyard::InstanceStatus> status;
        VINEYARD_CHECK_OK(client.InstanceStatus(status));
        std::cout << "vineyard instance is: " << status->instance_id << std::endl;

        return 0;
      }
    EOS

    system ENV.cxx, "test.cc", "-std=c++17",
                    "-I#{Formula["apache-arrow"].include}",
                    "-I#{Formula["boost"].include}",
                    "-I#{include}",
                    "-I#{include}/vineyard",
                    "-I#{include}/vineyard/contrib",
                    "-L#{Formula["apache-arrow"].lib}",
                    "-L#{Formula["boost"].lib}",
                    "-L#{lib}",
                    "-larrow",
                    "-lboost_thread-mt",
                    "-lboost_system-mt",
                    "-lvineyard_client",
                    "-o", "test_vineyard_client"

    # prepare vineyardd
    vineyardd_pid = spawn bin/"vineyardd", "--norpc",
                                           "--meta=local",
                                           "--socket=#{testpath}/vineyard.sock"

    # sleep to let vineyardd get its wits about it
    sleep 10

    assert_equal("vineyard instance is: 0\n", shell_output("./test_vineyard_client #{testpath}/vineyard.sock"))
  ensure
    # clean up the vineyardd process before we leave
    Process.kill("HUP", vineyardd_pid)
  end
end
