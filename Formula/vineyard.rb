class Vineyard < Formula
  include Language::Python::Virtualenv

  desc "In-memory immutable data manager. (Project under CNCF)"
  homepage "https://v6d.io"
  url "https://github.com/v6d-io/v6d/releases/download/v0.11.3/v6d-0.11.3.tar.gz"
  sha256 "18befb052270d5cfd1280db571b9dbdeb876d988d308d7cee1deb5ddde0121a0"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "18e15854094ac71799d83dd723fa962b2da781d9a72168caac0dd947a45a8d54"
    sha256 arm64_monterey: "8d5a76c0f7b2b52b3ce14457aaae9a12dc2d650c2f06ae3af04524f43b873f5c"
    sha256 arm64_big_sur:  "25948c1ef148df3f69fbb0324942384b39a15303d174644dca6b96564f9b182c"
    sha256 ventura:        "ca0bdbe7948dfab6ee86ff4ccd1bece3a593a8b619ba78b9a39eba6535fe3de1"
    sha256 monterey:       "f6dbd6b5040dfc9c6b5b546c9f17fbdbbc0fa5f6a926e80e38f9cfdaa83acb03"
    sha256 big_sur:        "0dce7d6fb3ad4506d7123ec6a97461fb7203ea301f2ad4ea819e2f93195d18af"
    sha256 x86_64_linux:   "b10bcfddfe4a9cf0df81c0d8bfebb6972205b82cd6d287d5fc0b1b7a5c5fb6a3"
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
  depends_on "nlohmann-json"
  depends_on "open-mpi"
  depends_on "openssl@1.1"
  depends_on "tbb"

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
                    "-DUSE_EXTERNAL_TBB_LIBS=ON",
                    "-DUSE_EXTERNAL_NLOHMANN_JSON_LIBS=ON",
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
