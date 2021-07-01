class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://github.com/oneapi-src/oneTBB"
  url "https://github.com/oneapi-src/oneTBB/archive/refs/tags/v2021.3.0.tar.gz"
  sha256 "8f616561603695bbb83871875d2c6051ea28f8187dbe59299961369904d1d49e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5d62feb0d5a41fb14d49a133375e39d7712da8c3cd659577b6fa276d9443b315"
    sha256 cellar: :any, big_sur:       "d0077f75204853eb3cb03edb4b77c7eb480fc0817afbbbbc06c2e062ab3204d6"
    sha256 cellar: :any, catalina:      "15243389ba219a58819d62be1d90b769cb7e78f0a21860539988e1a6582b781b"
    sha256 cellar: :any, mojave:        "a0d90c33f249288339767ab72110d44950e82d8cdc1ddd6055c83645ebbfb848"
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
      on_macos do
        ENV["LDFLAGS"] = "-rpath #{opt_lib}"
      end

      ENV["TBBROOT"] = prefix
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
    end

    on_linux do
      inreplace prefix/"rml/CMakeFiles/irml.dir/flags.make",
                "#{HOMEBREW_LIBRARY}/Homebrew/shims/linux/super/g++-5",
                "/usr/bin/c++"
      inreplace prefix/"rml/CMakeFiles/irml.dir/build.make",
                "#{HOMEBREW_LIBRARY}/Homebrew/shims/linux/super/g++-5",
                "/usr/bin/c++"
      inreplace prefix/"rml/CMakeFiles/irml.dir/link.txt",
                "#{HOMEBREW_LIBRARY}/Homebrew/shims/linux/super/g++-5",
                "/usr/bin/c++"
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
