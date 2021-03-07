class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://github.com/oneapi-src/oneTBB"
  url "https://github.com/oneapi-src/oneTBB/archive/refs/tags/v2021.2.0.tar.gz"
  sha256 "cee20b0a71d977416f3e3b4ec643ee4f38cedeb2a9ff015303431dd9d8d79854"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "33b261262efc28bb46c9aa4ff6ae74bc51033cc9f5877c3312a52af07130d534"
    sha256 cellar: :any, big_sur:       "9a6b1cbf0b9f20d05075d9c7c905f7e06bf91c0dd7f5a0b7d46f0761fdb86097"
    sha256 cellar: :any, catalina:      "e73f880d133b99c5e30120df768cff884d5d66f93f4e84bfc8937f37f9e0b614"
    sha256 cellar: :any, mojave:        "b026eb8322c7984cdd1f5313ffd866c6d41a556ad8d7ebf1e713786724d83675"
    sha256 cellar: :any, high_sierra:   "ccf240dbcb30bfb33736130c77b7afbb12a8ca4208cc8244f66943ce6c0307d1"
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
      ENV["LDFLAGS"] = "-rpath #{opt_lib}"

      ENV["TBBROOT"] = prefix
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
    end
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
index da4f4f93..6c95bcde 100644
--- a/python/CMakeLists.txt
+++ b/python/CMakeLists.txt
@@ -49,8 +49,8 @@ add_test(NAME python_test
                  -DPYTHON_MODULE_BUILD_PATH=${PYTHON_BUILD_WORK_DIR}/build
                  -P ${PROJECT_SOURCE_DIR}/cmake/python/test_launcher.cmake)

-install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${PYTHON_BUILD_WORK_DIR}/build/lib/
-        DESTINATION ${CMAKE_INSTALL_LIBDIR}
+install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${PYTHON_BUILD_WORK_DIR}/
+        DESTINATION .
         COMPONENT tbb4py)

 if (UNIX AND NOT APPLE)
