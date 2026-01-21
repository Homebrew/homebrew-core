class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://uxlfoundation.github.io/oneTBB/"
  url "https://github.com/uxlfoundation/oneTBB/archive/refs/tags/v2022.3.0.tar.gz"
  sha256 "01598a46c1162c27253a0de0236f520fd8ee8166e9ebb84a4243574f88e6e50a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cc9fcdb5dd902f43174d0da933d9fd5cbefbc0a64782564b5b8193abc627ec0f"
    sha256 cellar: :any,                 arm64_sequoia: "c15f3cd373ecc7ce5187734d1c93ff10dd22e83ba7b4e67010ec65052649bab6"
    sha256 cellar: :any,                 arm64_sonoma:  "6c12a8bf6407d61c277c7f99638af11c5600ec21af20f43319f49c4bb2fb69b9"
    sha256 cellar: :any,                 sonoma:        "8a759acc184a76c75165db15bd39903332e980221963da164b8a0356780acfcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cac87ad2e8f4fbf64aea23ea3ed64a54b8df675102b3013a09407ea0f43fb0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8e86274bf47f0546c742ffbd718b78c83703e3d6f8a2cd33ca7bd93c34b9291"
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
    # Prevent `setup.py` from installing tbb4py as a deprecated egg directly into HOMEBREW_PREFIX.
    # We need this due to our Python patch.
    site_packages = Language::Python.site_packages(python3)
    inreplace "python/CMakeLists.txt",
              "install --prefix build -f",
              "\\0 --install-lib build/#{site_packages} --single-version-externally-managed --record=RECORD"

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
