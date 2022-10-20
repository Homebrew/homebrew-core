class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://github.com/oneapi-src/oneTBB"
  url "https://github.com/oneapi-src/oneTBB/archive/refs/tags/v2021.6.0.tar.gz"
  sha256 "4897dd106d573e9dacda8509ca5af1a0e008755bf9c383ef6777ac490223031f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ae7e8f1af052a35b96f5dafa33b6c7034a72467e6d6d57a2940e81eca38f10ab"
    sha256 cellar: :any,                 arm64_big_sur:  "f98ddae67691e3cd8c1f89db0b3f9dfd117b147d21e628fb1681fc59bc7a4905"
    sha256 cellar: :any,                 monterey:       "d73ec8f94707e2545b4ae057d8876d20ba47a0e53c75276ab9406e0895a6066c"
    sha256 cellar: :any,                 big_sur:        "87fc6a4cd9e698357d156140e8a98d4538d069d977ad1ee6840b170cf6568113"
    sha256 cellar: :any,                 catalina:       "8fb9a240fddfe26367118f82e409d1028773faac1996821abfc41c9c6bb17807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6a630dac8201adfad7c9861ad3590a2053b417f5e5ea088087b8233343afdea"
  end

  # If adding `hwloc` for TBBBind, you *must* add a test for its functionality.
  # https://github.com/oneapi-src/oneTBB/blob/690aaf497a78a75ff72cddb084579427ab0a8ffc/CMakeLists.txt#L226-L228
  depends_on "cmake" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "swig" => :build

  # Fix installation of Python components
  # See https://github.com/oneapi-src/oneTBB/issues/343
  patch :DATA

  # Fix thread creation under heavy load.
  # https://github.com/oneapi-src/oneTBB/pull/824
  # Needed for mold: https://github.com/rui314/mold/releases/tag/v1.4.0
  patch do
    url "https://github.com/oneapi-src/oneTBB/commit/f12c93efd04991bc982a27e2fa6142538c33ca82.patch?full_index=1"
    sha256 "637a65cca11c81fa696112aca714879a2202a20e426eff2be8d2318e344ae15c"
  end

  def install
    # Prevent `setup.py` from installing tbb4py directly into HOMEBREW_PREFIX.
    # We need this due to our `python@3.10` patch.
    python = Formula["python@3.10"].opt_bin/"python3.10"
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

    system Formula["python@3.10"].opt_bin/"python3.10", "-c", "import tbb"
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
