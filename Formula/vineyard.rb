class Vineyard < Formula
  include Language::Python::Virtualenv

  desc "In-memory immutable data manager. (Project under CNCF)"
  homepage "https://v6d.io"
  url "https://github.com/v6d-io/v6d/releases/download/v0.8.2/v6d-0.8.2.tar.gz"
  sha256 "75f93b718bebbe97ce3ce7d678a5b0d05baa86196ab111c44fcab8f087411676"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_monterey: "f1c8dbc80b09db8570e39cfe55de5cba055b9c801f0759e96d6a08b59513ddad"
    sha256                               arm64_big_sur:  "058257ac857f9e062624df501bb21c671146c78963e12481ac8727b649957730"
    sha256                               monterey:       "f72721e8826996ea1a36c3316f0d5bfe075d9935a58300fbb7ed5cfcb1d7e44c"
    sha256                               big_sur:        "80b711993c5a15fabb67b7eca2caa19d2d2b79bef19d1b47a142830776ee88e9"
    sha256                               catalina:       "f0c8edad76f880c51a26f0fc37b47b7a16c74eb1c0a278c7ae3fbaa03a9f7dd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5afab78aace2f7d91aa6e51b2d2eaaaff898bc93a9db1dc3f87d59a5efbee3bd"
  end

  depends_on "cmake" => :build
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

  resource "libclang" do
    url "https://files.pythonhosted.org/packages/ea/ec/94fefe778caa8f2ecf9bb996917535a49b36580846af908b2f38fe6396c9/libclang-14.0.1.tar.gz"
    sha256 "332e539201b46cd4676bee992bbf4b3e50450fc17f71ff33d4afc9da09cf46cb"
  end

  def install
    # We install the libclang from pypi for build as the `clang` package
    # bundled in LLVM cannot find libclang.dylib easily.
    #
    # The requirement for libclang python package will be removed once
    # LLVM been upgrade to 15, see also: Homebrew/homebrew-core#106925
    venv = virtualenv_create(buildpath/"venv", "python3")
    venv.pip_install resource("libclang")

    # make libclang.so/libclang.dll findable by clang.cindex.Index.create()
    ENV["LIBCLANG_LIBRARY_PATH"] = Formula["llvm"].opt_lib

    # link against system libc++ instead of llvm provided libc++
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=14",
                    "-DCMAKE_CXX_STANDARD_REQUIRED=TRUE",
                    "-DPYTHON_EXECUTABLE=#{buildpath}/venv/bin/python",
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
