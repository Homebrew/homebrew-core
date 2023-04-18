class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://github.com/oneapi-src/oneTBB"
  url "https://github.com/oneapi-src/oneTBB/archive/refs/tags/v2021.9.0.tar.gz"
  sha256 "1ce48f34dada7837f510735ff1172f6e2c261b09460e3bf773b49791d247d24e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8b0fb0da10b496d0671163b50e1782285cf59caf90f020745d714befacf16880"
    sha256 cellar: :any,                 arm64_monterey: "97be69a42e06cc72927871a212dced7ee1a772fa6da4b817a779442b33c5b7cd"
    sha256 cellar: :any,                 arm64_big_sur:  "e90bca15b4f94460841a2f9eb15c752082f103808dd2be8fa488bc42a357ea13"
    sha256 cellar: :any,                 ventura:        "bda98398575da5a8184d49ac715abff5efeb1f82b3a5dfa6be23eb501cfc0e15"
    sha256 cellar: :any,                 monterey:       "bf557c58fbc39ba23c3df0714bdf12bbe9e87ec0f5109d09dc0da357de5f19ba"
    sha256 cellar: :any,                 big_sur:        "173769f4d52a341b0d77cfaad0e611038a5798fd3d32a44a8459ca7a26f141a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14f6077f8872a9b6b560b2f93ec36fd1e2c26c45e7fa5d38285f11a943284a89"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "swig" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "hwloc"
  end

  # Fix installation of Python components
  patch :DATA

  def install
    # Prevent `setup.py` from installing tbb4py directly into HOMEBREW_PREFIX.
    # We need this due to our `python@3.11` patch.
    python = Formula["python@3.11"].opt_bin/"python3.11"
    site_packages = Language::Python.site_packages(python)
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

      system python, *Language::Python.setup_install_args(prefix, python)
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

    system Formula["python@3.11"].opt_bin/"python3.11", "-c", "import tbb"
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
