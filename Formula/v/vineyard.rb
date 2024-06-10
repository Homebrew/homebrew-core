class Vineyard < Formula
  include Language::Python::Virtualenv

  desc "In-memory immutable data manager. (Project under CNCF)"
  homepage "https://v6d.io"
  url "https://github.com/v6d-io/v6d/releases/download/v0.22.2/v6d-0.22.2.tar.gz"
  sha256 "f8a9231edf38f6dff37004746dcd4bdeb4a8de30b10ecadd41a6bbbd51047af1"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "e16d847a302ca6777325512a291056adc59080bed0b18dadf1206b7ecb27e74c"
    sha256                               arm64_ventura:  "2aa841f7ea307892d2ebfd2c21174f299b6f2b56ed051f38d79dcde23af198cf"
    sha256                               arm64_monterey: "53001a1824f92ebfe46ee0cd30a20019a8e4ed3ab30472e12b12e1db8476e164"
    sha256                               sonoma:         "e9b6cfde154473069e67d48c02692c86fd5b0881d79398629cd29e3cc5a4b505"
    sha256                               ventura:        "3214409eece19734846d92cbda65a207fbd70b03ec1a6c57c93478421134f6df"
    sha256                               monterey:       "2996a9d418e9226d31bdb4eff2e9d372efa97faf935b7cc809bda1ea3d89356a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7efea12935435dadb44bd3bc9982cc49667b81b88ed284ecf854ef2b31e7f12a"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "llvm" => [:build, :test]
  depends_on "python@3.12" => :build
  depends_on "apache-arrow"
  depends_on "boost"
  depends_on "cpprestsdk"
  depends_on "etcd"
  depends_on "etcd-cpp-apiv3"
  depends_on "gflags"
  depends_on "glog"
  depends_on "grpc"
  depends_on "hiredis"
  depends_on "libgrape-lite"
  depends_on "open-mpi"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "redis"

  on_macos do
    depends_on "abseil"
    depends_on "c-ares"
    depends_on "re2"
  end

  fails_with gcc: "5"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/aa/60/5db2249526c9b453c5bb8b9f6965fcab0ddb7f40ad734420b3b421f7da44/setuptools-70.0.0.tar.gz"
    sha256 "f211a66637b8fa059bb28183da127d4e86396c991a942b028c6650d4319c3fd0"
  end

  def install
    python = "python3.12"
    venv = virtualenv_create(libexec, python)
    venv.pip_install resources
    # LLVM is keg-only.
    ENV.prepend_path "PYTHONPATH", Formula["llvm"].opt_prefix/Language::Python.site_packages(python)

    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17",
                    "-DCMAKE_CXX_STANDARD_REQUIRED=TRUE",
                    "-DPYTHON_EXECUTABLE=#{venv.root}/bin/python",
                    "-DUSE_EXTERNAL_ETCD_LIBS=ON",
                    "-DUSE_EXTERNAL_REDIS_LIBS=ON",
                    "-DUSE_EXTERNAL_HIREDIS_LIBS=ON",
                    "-DBUILD_VINEYARD_TESTS=OFF",
                    "-DUSE_LIBUNWIND=OFF",
                    "-DLIBGRAPELITE_INCLUDE_DIRS=#{Formula["libgrape-lite"].opt_include}",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
                    "-DBUILD_VINEYARD_SERVER_ETCD=OFF", # Fails with protobuf 27
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

    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)

      project(vineyard-test LANGUAGES C CXX)

      find_package(vineyard REQUIRED)

      add_executable(vineyard-test ${CMAKE_CURRENT_SOURCE_DIR}/test.cc)
      target_include_directories(vineyard-test PRIVATE ${VINEYARD_INCLUDE_DIRS})
      target_link_libraries(vineyard-test PRIVATE ${VINEYARD_LIBRARIES})
    EOS

    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    # Remove Homebrew's lib directory from LDFLAGS as it is not available during
    # `shell_output`.
    ENV.remove "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    # macos AppleClang doesn't support -fopenmp
    system "cmake", "-S", testpath, "-B", testpath/"build",
                    "-DCMAKE_C_COMPILER=#{Formula["llvm"].bin}/clang",
                    "-DCMAKE_CXX_COMPILER=#{Formula["llvm"].bin}/clang++",
                    *std_cmake_args
    system "cmake", "--build", testpath/"build"

    # prepare vineyardd
    vineyardd_pid = spawn bin/"vineyardd", "--norpc",
                                           "--meta=local",
                                           "--socket=#{testpath}/vineyard.sock"

    # sleep to let vineyardd get its wits about it
    sleep 10

    assert_equal("vineyard instance is: 0\n",
                 shell_output("#{testpath}/build/vineyard-test #{testpath}/vineyard.sock"))
  ensure
    # clean up the vineyardd process before we leave
    Process.kill("HUP", vineyardd_pid)
  end
end
