class Vineyard < Formula
  include Language::Python::Virtualenv

  desc "In-memory immutable data manager. (Project under CNCF)"
  homepage "https://v6d.io"
  url "https://github.com/v6d-io/v6d/releases/download/v0.10.1/v6d-0.10.1.tar.gz"
  sha256 "b9ce123edad62d690fd579dbb6950a7aca54ec7f4b237aefc7032dcb17a25b1f"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 arm64_ventura:  "1534bd78f700fbfd5a276ae07857023af94515a58b9c7459b42997def55f96a5"
    sha256 arm64_monterey: "54d32f5219c127fcd15a79866718bbf18ba55cc276a48617671a0ac27453cd26"
    sha256 arm64_big_sur:  "a9c4c8931da88f86b8ad2e0f55dd1cf1c6aca475418b99f357f3dfb10c5dd8b9"
    sha256 monterey:       "b495299eb2531cde0128b45ef578d2b7bea90869b01a6e38b57414022be5aaaf"
    sha256 big_sur:        "a76d5392935504a89962d6141a5ba2e9740d267bfb3e5344a027cef233b7ae0b"
    sha256 catalina:       "e73d382d7d19c0be04e43c49aba653cad054a938ef41d73b37914f4b5b9e9b15"
    sha256 x86_64_linux:   "45c25423f20e65cc7b65c256a7079f58d99d8847715dcc6bcf29e8d342cc6f6c"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build
  depends_on "apache-arrow"
  depends_on "boost"
  depends_on "etcd"
  depends_on "etcd-cpp-apiv3"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libgrape-lite"
  depends_on "llvm"
  depends_on "nlohmann-json"
  depends_on "open-mpi"
  depends_on "openssl@1.1"
  depends_on "tbb"

  fails_with gcc: "5"

  def install
    python = "python3.10"
    # LLVM is keg-only.
    ENV.prepend_path "PYTHONPATH", Formula["llvm"].opt_prefix/Language::Python.site_packages(python)

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=14",
                    "-DCMAKE_CXX_STANDARD_REQUIRED=TRUE",
                    "-DPYTHON_EXECUTABLE=#{which(python)}",
                    "-DUSE_EXTERNAL_ETCD_LIBS=ON",
                    "-DUSE_EXTERNAL_TBB_LIBS=ON",
                    "-DUSE_EXTERNAL_NLOHMANN_JSON_LIBS=ON",
                    "-DBUILD_VINEYARD_TESTS=OFF",
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
