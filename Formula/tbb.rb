class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://github.com/oneapi-src/oneTBB"
  url "https://github.com/oneapi-src/oneTBB/archive/refs/tags/v2021.3.0.tar.gz"
  sha256 "8f616561603695bbb83871875d2c6051ea28f8187dbe59299961369904d1d49e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "0b38fba5657af959e0e2392daa9163309c51b469e7db92c5b70f535c554ab63a"
    sha256 cellar: :any,                 big_sur:       "18d284f2fa0792ab119b10260eebc9a87fd00dc68cf0fdcd70ee00d6d7af5570"
    sha256 cellar: :any,                 catalina:      "953989fa59711ea79f8690ae08a79a4a7722325fa36445ddffaf11c6729e25ee"
    sha256 cellar: :any,                 mojave:        "e2c2e8c35d0df2fc1659c59c0b501b0e2420c43a6d8afe629c9f49afa1bae236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "826e5e4bdbcdec6e72a99bb61a6d89eba61438d3f820af714e9e684cb0f085c9"
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "python@3.9"

  # Fix installation of Python components
  # See https://github.com/oneapi-src/oneTBB/issues/343
  patch :DATA

  def install
    args = *std_cmake_args + %w[
      -DTBB_TEST=OFF
      -DTBB4PY_BUILD=ON
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    cd "python" do
      ENV.append_path "CMAKE_PREFIX_PATH", prefix.to_s
      ENV["LDFLAGS"] = "-rpath #{opt_lib}" if OS.mac?

      ENV["TBBROOT"] = prefix
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
    end

    inreplace_files = Dir[prefix/"rml/CMakeFiles/irml.dir/{flags.make,build.make,link.txt}"]
    inreplace inreplace_files, Superenv.shims_path/ENV.cxx, "/usr/bin/c++" if OS.linux?
  end

  test do
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

    system Formula["python@3.9"].opt_bin/"python3", "-c", "import tbb"
  end
end

__END__
diff --git a/python/CMakeLists.txt b/python/CMakeLists.txt
index 1d2b05f..81ba8de 100644
--- a/python/CMakeLists.txt
+++ b/python/CMakeLists.txt
@@ -49,7 +49,7 @@ add_test(NAME python_test
                  -DPYTHON_MODULE_BUILD_PATH=${PYTHON_BUILD_WORK_DIR}/build
                  -P ${PROJECT_SOURCE_DIR}/cmake/python/test_launcher.cmake)

-install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${PYTHON_BUILD_WORK_DIR}/build/
+install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${PYTHON_BUILD_WORK_DIR}/
         DESTINATION .
         COMPONENT tbb4py)
