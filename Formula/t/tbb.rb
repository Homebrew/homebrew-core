class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://uxlfoundation.github.io/oneTBB/"
  url "https://github.com/uxlfoundation/oneTBB/archive/refs/tags/v2023.1.0.tar.gz"
  sha256 "191288b52e1e6b17198000b64d77d194bb65e791be46ebc606e9b091781e2070"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a22d949f7716fb25f1bf7a35a7357206ef36a581f63b27a1025c690913736cb5"
    sha256 cellar: :any, arm64_sequoia: "d70b4cecfb5f3803554856437de3713380a13b81eb19bfe02569d2bdc03a486e"
    sha256 cellar: :any, arm64_sonoma:  "716d0f6b514266c1927263ba37f5bdc9bafccde459d257d2def6683631dc98ee"
    sha256 cellar: :any, sonoma:        "eb65a529712d2fc817da657279ca634d949ff2e25a222324c394bef788c7946c"
    sha256 cellar: :any, arm64_linux:   "c4e171925dca51b9e1dd4b8c13cda476825df2e5ecd74586d5899efbec2218c2"
    sha256 cellar: :any, x86_64_linux:  "d07e15ec5922544419b1ee6bc05020f52d41144e79fcf01b6bd3b7b40c0cb8b1"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "swig" => :build
  depends_on "hwloc"

  def python3
    "python3.14"
  end

  def install
    site_packages = Language::Python.site_packages(python3)
    tbb_site_packages = prefix/site_packages/"tbb"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath},-rpath,#{rpath(source: tbb_site_packages)}"

    args = %W[
      -DTBB_TEST=OFF
      -DTBB4PY_BUILD=ON
      -DPYTHON_EXECUTABLE=#{which(python3)}
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
  end

  test do
    # The glob that installs these might fail,
    # so let's check their existence.
    assert_path_exists lib/"libtbb.a"
    assert_path_exists lib/"libtbbmalloc.a"

    (testpath/"cores-types.cpp").write <<~CPP
      #include <cstdlib>
      #include <tbb/task_arena.h>

      int main() {
          const auto numa_nodes = tbb::info::numa_nodes();
          const auto size = numa_nodes.size();
          const auto type = numa_nodes.front();
          return size != 1 || type != tbb::task_arena::automatic ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    CPP

    system ENV.cxx, "cores-types.cpp", "-std=c++14", "-DTBB_PREVIEW_TASK_ARENA_CONSTRAINTS_EXTENSION=1",
                                      "-L#{lib}", "-ltbb", "-o", "core-types"
    system "./core-types"

    (testpath/"sum1-100.cpp").write <<~CPP
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
    CPP

    system ENV.cxx, "sum1-100.cpp", "-std=c++14", "-L#{lib}", "-ltbb", "-o", "sum1-100"
    assert_equal "5050", shell_output("./sum1-100").chomp

    system python3, "-c", "import tbb"
  end
end
