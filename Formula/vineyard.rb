class Vineyard < Formula
  include Language::Python::Virtualenv

  desc "In-memory immutable data manager. (Project under CNCF)"
  homepage "https://v6d.io"
  url "https://github.com/v6d-io/v6d/releases/download/v0.9.0/v6d-0.9.0.tar.gz"
  sha256 "bd1e5ba09c162e1ff046266644bf18065a50ee1a4ad1def483cab62051cadb03"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 arm64_monterey: "2d54fdd6363c8e3b9dd9c23183d2476924ecaf0f04f5df0d0379d42ffe738180"
    sha256 arm64_big_sur:  "69a4a890e2cf658c52384d1e42fcd34932365d8bb5e23d37d3676ed45289e872"
    sha256 monterey:       "e99c518baf85ac291fd0c70e6bb0ae03eef04d6012b563747c107b776c689145"
    sha256 big_sur:        "4986ff03f669da82c8d08be9ee84c4231014c6b3eb24adb03cb09c6a7dbb4e59"
    sha256 catalina:       "a1cd3f3c80c27e74debf016cf5b60b627517193ed81096accb0fe58ac653ff70"
    sha256 x86_64_linux:   "3731345ef9e6282a34b9d967b3c22c6658bdace4e4138ca378b0d3a3d1c5edac"
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
