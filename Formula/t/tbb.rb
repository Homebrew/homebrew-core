class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://github.com/oneapi-src/oneTBB"
  url "https://github.com/oneapi-src/oneTBB/archive/refs/tags/v2021.10.0.tar.gz"
  sha256 "487023a955e5a3cc6d3a0d5f89179f9b6c0ae7222613a7185b0227ba0c83700b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "82aedbedc4f01d9e859ec0c0702a04cd61c300c9e6941239e8eae120eff4bd57"
    sha256 cellar: :any,                 arm64_ventura:  "111d9a40d50f16615cfa8d543aba48d55482b4b234154a172309bf62c5a5d2d6"
    sha256 cellar: :any,                 arm64_monterey: "beefab871bae0c31c9ced93653db9f3d4ee0e77c708252aae7a395560bd8e8ff"
    sha256 cellar: :any,                 arm64_big_sur:  "e4d19bdf3991e80b81217bd45f770acab8841f1701a004ece15d2e581b34e2d3"
    sha256 cellar: :any,                 sonoma:         "eb9180328e0efdc0426cbb08ca79d736c2796c68f9d260a43cf5406409201968"
    sha256 cellar: :any,                 ventura:        "54c8bbc3954d70aaa5c37ff01c64e4d5873c96f9f9c87442e13d11c00e5a6436"
    sha256 cellar: :any,                 monterey:       "18759017f100a1a974c7126577d06ce8a18fcc0b4ae0d448c692b7d38ac6db93"
    sha256 cellar: :any,                 big_sur:        "ea0fbb62658f0179c96b309eafe7068434c131bf89926f02f9e89c7daf5a0de5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6071625843f701c8a904882b90f647ab0e7307656bec78f4066430639b1b866a"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "swig" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "hwloc"
  end

  # Fix installation of Python components
  # See See https://github.com/oneapi-src/oneTBB/issues/343
  patch :DATA

  def python3
    "python3.11"
  end

  def install
    # Prevent `setup.py` from installing tbb4py directly into HOMEBREW_PREFIX.
    # We need this due to our `python@3.11` patch.
    site_packages = Language::Python.site_packages(python3)
    inreplace "python/CMakeLists.txt", "@@SITE_PACKAGES@@", site_packages

    tbb_site_packages = prefix/site_packages/"tbb"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath},-rpath,#{rpath(source: tbb_site_packages)}"

    args = %w[
      -DTBB_TEST=OFF
      -DTBB4PY_BUILD=ON
    ]

    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install buildpath.glob("build/static/*/libtbb*.a")

    cd "python" do
      ENV.append_path "CMAKE_PREFIX_PATH", prefix.to_s
      ENV["TBBROOT"] = prefix

      system python3, "-m", "pip", "install", *std_pip_args, "."
    end

    return unless OS.linux?

    inreplace_files = prefix.glob("rml/CMakeFiles/irml.dir/{flags.make,build.make,link.txt}")
    inreplace inreplace_files, Superenv.shims_path/ENV.cxx, ENV.cxx
  end

  test do
    # The glob that installs these might fail,
    # so let's check their existence.
    assert_path_exists lib/"libtbb.a"
    assert_path_exists lib/"libtbbmalloc.a"

    # on macOS core types are not distinguished, because libhwloc does not support it for now
    # see https://github.com/oneapi-src/oneTBB/blob/690aaf497a78a75ff72cddb084579427ab0a8ffc/CMakeLists.txt#L226-L228
    (testpath/"cores-types.cpp").write <<~EOS
      #include <cstdlib>
      #include <tbb/task_arena.h>

      int main() {
          const auto numa_nodes = tbb::info::numa_nodes();
          const auto size = numa_nodes.size();
          const auto type = numa_nodes.front();
      #ifdef __APPLE__
          return size == 1 && type == tbb::task_arena::automatic ? EXIT_SUCCESS : EXIT_FAILURE;
      #else
          return size != 1 || type != tbb::task_arena::automatic ? EXIT_SUCCESS : EXIT_FAILURE;
      #endif
      }
    EOS

    system ENV.cxx, "cores-types.cpp", "--std=c++14", "-DTBB_PREVIEW_TASK_ARENA_CONSTRAINTS_EXTENSION=1",
                                      "-L#{lib}", "-ltbb", "-o", "core-types"
    system "./core-types"

    (testpath/"sum1-100.cpp").write <<~EOS
      #include <iostream>
      #include <tbb/blocked_range.h>
      #include <tbb/parallel_reduce.h>

      int main()
      {
        auto total = tbb::parallel_reduce(
          tbb::blocked_range<int>(0, 100),
          0.0,
          [&](tbb::blocked_range<int> r, int running_total)
          {
            for (int i=r.begin(); i < r.end(); ++i) {
              running_total += i + 1;
            }

            return running_total;
          }, std::plus<int>()
        );

        std::cout << total << std::endl;
        return 0;
      }
    EOS

    system ENV.cxx, "sum1-100.cpp", "--std=c++14", "-L#{lib}", "-ltbb", "-o", "sum1-100"
    assert_equal "5050", shell_output("./sum1-100").chomp

    system python3, "-c", "import tbb"
  end
end

__END__
diff --git a/python/CMakeLists.txt b/python/CMakeLists.txt
index 1d2b05f..81ba8de 100644
--- a/python/CMakeLists.txt
+++ b/python/CMakeLists.txt
@@ -40,7 +40,7 @@ add_custom_target(
     ${PYTHON_EXECUTABLE} ${PYTHON_BUILD_WORK_DIR}/setup.py
         build -b${PYTHON_BUILD_WORK_DIR}
         build_ext ${TBB4PY_INCLUDE_STRING} -L$<TARGET_FILE_DIR:TBB::tbb>
-        install --prefix ${PYTHON_BUILD_WORK_DIR}/build -f
+        install --prefix ${PYTHON_BUILD_WORK_DIR}/build --install-lib ${PYTHON_BUILD_WORK_DIR}/build/@@SITE_PACKAGES@@ -f
     COMMENT "Build and install to work directory the oneTBB Python module"
 )
 
@@ -49,7 +49,7 @@ add_test(NAME python_test
                  -DPYTHON_MODULE_BUILD_PATH=${PYTHON_BUILD_WORK_DIR}/build
                  -P ${PROJECT_SOURCE_DIR}/cmake/python/test_launcher.cmake)

-install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${PYTHON_BUILD_WORK_DIR}/build/
+install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${PYTHON_BUILD_WORK_DIR}/
         DESTINATION .
         COMPONENT tbb4py)
