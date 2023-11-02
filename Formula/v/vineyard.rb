class Vineyard < Formula
  include Language::Python::Virtualenv

  desc "In-memory immutable data manager. (Project under CNCF)"
  homepage "https://v6d.io"
  url "https://github.com/v6d-io/v6d/releases/download/v0.18.0/v6d-0.18.0.tar.gz"
  sha256 "c08ba6a320c742ab6bb14bc24d07811cb6f4a91cd85f213921256e7c29059318"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "4856eb75bf97175c23ed9d8d9d8b41fab84324d7e16017633132184710caf9b8"
    sha256                               arm64_ventura:  "bbef09ae2ba817bc09145bb74c7cc63ae02a2aa99aad3a0afec1c8493d640f79"
    sha256                               arm64_monterey: "f78217ba68b6be25a710fd3732b106751447a4449f21dc02dfe3b402ab1ffa34"
    sha256                               sonoma:         "2f4f6480e1e5b1269e06586fef5c33efc0d8a78256300b81efef784200fa3616"
    sha256                               ventura:        "d16c1889579a535c6d72d73fb681f99055a8a032d9df97e16158237d681abdbf"
    sha256                               monterey:       "eb8f11abd41a1dc55efe6feec9d7b575ce246b452d9093ba76b3c8773b04d1d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6007f003b7e9caf575a7081ebeb2a78d5611e3bf244c73b9dfa6d24bc31512e8"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "llvm" => [:build, :test]
  depends_on "python@3.11" => :build
  depends_on "apache-arrow"
  depends_on "boost"
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

  fails_with gcc: "5"

  def install
    python = "python3.11"
    # LLVM is keg-only.
    ENV.prepend_path "PYTHONPATH", Formula["llvm"].opt_prefix/Language::Python.site_packages(python)

    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17",
                    "-DCMAKE_CXX_STANDARD_REQUIRED=TRUE",
                    "-DPYTHON_EXECUTABLE=#{which(python)}",
                    "-DUSE_EXTERNAL_ETCD_LIBS=ON",
                    "-DUSE_EXTERNAL_REDIS_LIBS=ON",
                    "-DUSE_EXTERNAL_HIREDIS_LIBS=ON",
                    "-DBUILD_VINEYARD_TESTS=OFF",
                    "-DUSE_LIBUNWIND=OFF",
                    "-DLIBGRAPELITE_INCLUDE_DIRS=#{Formula["libgrape-lite"].opt_include}",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
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
