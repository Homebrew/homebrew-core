class Vineyard < Formula
  include Language::Python::Virtualenv

  desc "In-memory immutable data manager. (Project under CNCF)"
  homepage "https://v6d.io"
  url "https://github.com/v6d-io/v6d/releases/download/v0.13.0/v6d-0.13.0.tar.gz"
  sha256 "e3d431466f058e1c8a27f0ab1bb1e189bee1fcf4dfc7293a0d5e33991f68575f"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "6b9be958a22927bba30a2bd55a3e4cf891a2a30160cca53beed548a14ce3c26b"
    sha256 arm64_monterey: "05f74d0b01e679f42e5d07056dde8064debcbec53f9ebba6ba240894a88db35f"
    sha256 arm64_big_sur:  "cf908ea2c3d4c13121263682a4cf694eb7307c8c2f95f85e34c7de628e4424fd"
    sha256 ventura:        "75c7ccf958edbd33ce24c59fed761a57bed0d4508f8c5718d86efd224ac58621"
    sha256 monterey:       "e35de9b04c54a7693ae75657039c98bf791e51d497a52fb0cd738615037845ab"
    sha256 big_sur:        "c5a3b1817c2bbcf6f7fc1452507cfa4d0aa0634aa844c99a20ceff9d3ea4a2ce"
    sha256 x86_64_linux:   "ed209beb707cf8458a43324041448412140f186a7ddda644a2a4e27372efa0a8"
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
