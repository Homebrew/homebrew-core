class Vineyard < Formula
  include Language::Python::Virtualenv

  desc "In-memory immutable data manager. (Project under CNCF)"
  homepage "https://v6d.io"
  url "https://github.com/v6d-io/v6d/releases/download/v0.23.2/v6d-0.23.2.tar.gz"
  sha256 "2a2788ed77b9459477b3e90767a910e77e2035a34f33c29c25b9876568683fd4"
  license "Apache-2.0"
  revision 10

  bottle do
    sha256                               arm64_sequoia: "c3eac575a2aaff6fa96d52a20fca63c835bff98df7f13d447ace337a1a3d0362"
    sha256                               arm64_sonoma:  "81608d820bef177151e05aea0a83e5ca0bb60e9ce98e23272e3d372290786479"
    sha256                               arm64_ventura: "c88adc7468177d4dbf1d7a8ce91b778b7765f4890cbec7f66325aa51da2f22d7"
    sha256                               sonoma:        "7ada9613504c73c05a6c351a74f862dced728305d7bb0183887475cf3ed461f4"
    sha256                               ventura:       "15e8735681e8606f09140dd09fd3cd30d6b8db759068903860e7bd1dd199c85e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6818be9d20995171e1f209bb615be7fac5380fe64ba17e644d971acbb170fa31"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "llvm" => :build # for clang Python bindings
  depends_on "openssl@3" => :build # indirect (not linked) but CMakeLists.txt checks for it
  depends_on "python@3.13" => :build
  depends_on "apache-arrow"
  depends_on "boost@1.85"
  depends_on "cpprestsdk"
  depends_on "etcd"
  depends_on "etcd-cpp-apiv3"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libgrape-lite"
  depends_on "open-mpi"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  def install
    python3 = "python3.13"
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    # LLVM is keg-only.
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
    ENV.prepend_path "PYTHONPATH", llvm.opt_prefix/Language::Python.site_packages(python3)

    args = [
      "-DBUILD_VINEYARD_PYTHON_BINDINGS=OFF",
      "-DBUILD_VINEYARD_TESTS=OFF",
      "-DCMAKE_CXX_STANDARD=17",
      "-DCMAKE_CXX_STANDARD_REQUIRED=TRUE",
      "-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON", # for newer protobuf
      "-DLIBGRAPELITE_INCLUDE_DIRS=#{Formula["libgrape-lite"].opt_include}",
      "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
      "-DPYTHON_EXECUTABLE=#{venv.root}/bin/python",
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
