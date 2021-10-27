class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://github.com/oneapi-src/oneTBB"
  url "https://github.com/oneapi-src/oneTBB/archive/refs/tags/v2021.4.0.tar.gz"
  sha256 "021796c7845e155e616f5ecda16daa606ebb4c6f90b996e5c08aebab7a8d3de3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ab51e857beba9a5eaa3a8e265bb39443f6be0af06ce0e637b37d2c322b5b0eed"
    sha256 cellar: :any,                 arm64_big_sur:  "562dbe3727195b7d22f5750f720ab8719e84dd557f120af380fe65ebf1de0f71"
    sha256 cellar: :any,                 monterey:       "dcbc8429653c9953eeb40e73f228ebbdfca7e86bbcc13ddc9078fc67531660cc"
    sha256 cellar: :any,                 big_sur:        "292efca6f88d8dc0dd396593ec9cd7fffee60457968f3bf4911e595e67b0e4e5"
    sha256 cellar: :any,                 catalina:       "ceab79696162f301977698d1274dfc220de372ba473845c0b89ce29572e2c54b"
    sha256 cellar: :any,                 mojave:         "d5c1155379f21962bc47d172a9b673c4a72b24656b5f7fed5990d3e34b909c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dfbbb5d279074f2bc885ef3fa4c8e28faf69115434f1e58212bc3b027e36fcf"
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
