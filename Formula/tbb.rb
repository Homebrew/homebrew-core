class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://github.com/oneapi-src/oneTBB"
  url "https://github.com/oneapi-src/oneTBB/archive/refs/tags/v2021.5.0.tar.gz"
  sha256 "e5b57537c741400cf6134b428fc1689a649d7d38d9bb9c1b6d64f092ea28178a"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c70f9d3c24cb86290c6d371179f6d01afcdd13c3a9bad26ee36baa2262c142a8"
    sha256 cellar: :any,                 arm64_big_sur:  "4e6a51639e5a92a15b5a52abf3937870536eb97273228635698a82da78757b65"
    sha256 cellar: :any,                 monterey:       "8323879a2adfcfc50d60fa20adcfe709a00797a1bc698d8cd3b967bd5f3bee2c"
    sha256 cellar: :any,                 big_sur:        "af411c6cabc26792c73f8605f7c22bd6ddec9405e30b32a2782592c1056b90ce"
    sha256 cellar: :any,                 catalina:       "244bb7fd1ae57141d3cd3eb01685f7364f475778fbb51fa8aa371c24737736fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa2dca8daa7a939d9dd52162911d95dee683b42c4b1f0e9cadb5fa0b5bf1a9dc"
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
      system "cmake", "..", *args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make"
      system "make", "install"
      system "make", "clean"
      system "cmake", "..", *args, "-DBUILD_SHARED_LIBS=OFF"
      system "make"
      lib.install Dir["**/libtbb*.a"]
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
