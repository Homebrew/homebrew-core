class Vineyard < Formula
  include Language::Python::Virtualenv

  desc "In-memory immutable data manager. (Project under CNCF)"
  homepage "https://v6d.io"
  url "https://github.com/v6d-io/v6d/releases/download/v0.14.5/v6d-0.14.5.tar.gz"
  sha256 "b8f6c7b148f86a3d68bf7c49282dacf00f1811c1313a1c18b557347cf3359485"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "63435e03f7367b4ebf8cc8441d18a89d9ab5e1675e084d31be7425120c30057c"
    sha256 arm64_monterey: "888f6600c54fea3242a234bb7173cd3be9d7f64aa23c8b0f3fb514e086620119"
    sha256 arm64_big_sur:  "f8771c7f769707ab159f10aded6b4e0b7438d6a4fc3a939cc6bcea98651be841"
    sha256 ventura:        "5c7a0930cd9a057e04e724728e862d2e719f55b71cf3070a44b182c3010622f5"
    sha256 monterey:       "184b8d39f932cd3ae24417f91a810cfcce4ecdf29ec888fd5a7120140f3516b9"
    sha256 big_sur:        "0e5a14a49c0caaaa6bded0b199d98a11a1704015b8367d61647a74299587f53f"
    sha256 x86_64_linux:   "9eb58aee342dc76e834407267034fc5b37e9046a81a55ff9980bde47fbf21075"
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
