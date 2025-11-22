class Vineyard < Formula
  desc "In-memory immutable data manager. (Project under CNCF)"
  homepage "https://v6d.io"
  url "https://github.com/v6d-io/v6d/releases/download/v0.24.4/v6d-0.24.4.tar.gz"
  sha256 "055bab09ca67542ccb13229de8c176b7875b4ba8c8a818e942218dccc32a6bae"
  license "Apache-2.0"
  revision 4

  bottle do
    sha256                               arm64_tahoe:   "292e0e764ac9cf8c41a8f981593d203c0617e6dd1b26f96690792d36b10f0258"
    sha256                               arm64_sequoia: "03495aa217e4224723d0a47b5370595b6d086a2315f1d9f66f90ce54f4497cf2"
    sha256                               arm64_sonoma:  "5a510addb297fb52f1eaffa5c6d5ad4c62c1c103e067ee7d6da931a79a74891d"
    sha256                               sonoma:        "434aeacc8b553a9d49644ae2498a77557f2a14c5c074f7998affdafd24e735ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ec940f0b0d2905faadf0370499b2088f997d938d62ebf4a1e81e6ab566fb760"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a403f9985962d521b08c3527ca71d5ca7472e6f47ef8c13e4d21c124573e1b2"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "llvm" => :build # for clang Python bindings
  depends_on "openssl@3" => :build # indirect (not linked) but CMakeLists.txt checks for it
  depends_on "python-setuptools" => :build
  depends_on "python@3.14" => :build
  depends_on "apache-arrow"
  depends_on "boost"
  depends_on "cpprestsdk"
  depends_on "etcd"
  depends_on "etcd-cpp-apiv3"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libgrape-lite"
  depends_on "open-mpi"

  on_tahoe do
    fails_with :clang do
      build 1700
      cause "https://github.com/llvm/llvm-project/issues/142118"
    end
  end

  on_linux do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # apache-arrow 21.0.0 support
  # https://github.com/v6d-io/v6d/pull/2052
  patch do
    url "https://github.com/v6d-io/v6d/commit/cab3ed986e15464d6b544a98bac4db38d0e89e3a.patch?full_index=1"
    sha256 "ce1325c893f210a3eae9ff29a8ab6cfa377d6672ab260db58de8522857856206"
  end

  def install
    # TODO: Remove after https://github.com/Homebrew/brew/pull/20696
    ENV.llvm_clang if OS.mac? && MacOS.version == :tahoe && DevelopmentTools.clang_build_version == 1700

    # Workaround to support Boost 1.87.0+ until upstream fix for https://github.com/v6d-io/v6d/issues/2041
    boost_asio_post_files = %w[
      src/server/async/socket_server.cc
      src/server/server/vineyard_server.cc
      src/server/services/etcd_meta_service.cc
      src/server/services/local_meta_service.cc
      src/server/services/local_meta_service.h
      src/server/services/meta_service.cc
    ]
    inreplace boost_asio_post_files, /^(\s*)(\S+)\.post\(/, "\\1boost::asio::post(\\2,"
    inreplace "src/server/services/etcd_meta_service.cc", "backoff_timer_->cancel(ec);", "backoff_timer_->cancel();"

    # Workaround to support Boost 1.88.0+
    # TODO: Try upstreaming fix along with above
    boost_process_files = %w[
      src/server/util/etcd_launcher.cc
      src/server/util/etcd_member.cc
      src/server/util/kubectl.cc
      src/server/util/proc.cc
      src/server/util/proc.h
      src/server/util/redis_launcher.h
    ]
    inreplace boost_process_files, '#include "boost/process.hpp"', ""
    inreplace "src/server/util/etcd_launcher.h", '#include "boost/process/child.hpp"', ""
    ENV.append "CXXFLAGS", "-std=c++17"
    ENV.append "CXXFLAGS", "-DBOOST_PROCESS_VERSION=1"
    headers = %w[args async child env environment io search_path]
    headers.each { |header| ENV.append "CXXFLAGS", "-include boost/process/v1/#{header}.hpp" }

    python3 = "python3.14"
    # LLVM is keg-only.
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
    ENV.prepend_path "PYTHONPATH", llvm.opt_prefix/Language::Python.site_packages(python3)

    args = [
      "-DBUILD_VINEYARD_PYTHON_BINDINGS=OFF",
      "-DBUILD_VINEYARD_TESTS=OFF",
      "-DCMAKE_CXX_STANDARD=17",
      "-DCMAKE_CXX_STANDARD_REQUIRED=TRUE",
      "-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON", # for newer protobuf
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
      "-DLIBGRAPELITE_INCLUDE_DIRS=#{Formula["libgrape-lite"].opt_include}",
      "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
      "-DPYTHON_EXECUTABLE=#{which(python3)}",
      "-DUSE_EXTERNAL_ETCD_LIBS=ON",
      "-DUSE_EXTERNAL_HIREDIS_LIBS=ON",
      "-DUSE_EXTERNAL_REDIS_LIBS=ON",
      "-DUSE_LIBUNWIND=OFF",
    ]
    args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Replace `open-mpi` Cellar path that breaks on `open-mpi` version/revision bumps.
    # CMake FindMPI uses REALPATH so there isn't a clean way to handle during generation.
    openmpi = Formula["open-mpi"]
    inreplace lib/"cmake/vineyard/vineyard-targets.cmake", openmpi.prefix.realpath, openmpi.opt_prefix
  end

  test do
    (testpath/"test.cc").write <<~CPP
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
    CPP

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)

      project(vineyard-test LANGUAGES C CXX)

      find_package(vineyard REQUIRED)

      add_executable(vineyard-test ${CMAKE_CURRENT_SOURCE_DIR}/test.cc)
      target_include_directories(vineyard-test PRIVATE ${VINEYARD_INCLUDE_DIRS})
      target_link_libraries(vineyard-test PRIVATE ${VINEYARD_LIBRARIES})
    CMAKE

    # Remove Homebrew's lib directory from LDFLAGS as it is not available during
    # `shell_output`.
    ENV.remove "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"

    vineyard_sock = testpath/"vineyard.sock"
    # prepare vineyardd
    vineyardd_pid = spawn bin/"vineyardd", "--norpc",
                                           "--meta=local",
                                           "--socket=#{vineyard_sock}"

    # sleep to let vineyardd get its wits about it
    sleep 10 until vineyard_sock.exist? && vineyard_sock.socket?

    assert_equal("vineyard instance is: 0\n",
                 shell_output("#{testpath}/build/vineyard-test #{vineyard_sock}"))
  ensure
    # clean up the vineyardd process before we leave
    Process.kill("HUP", vineyardd_pid)
  end
end
