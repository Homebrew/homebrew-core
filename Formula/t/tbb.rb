class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://github.com/oneapi-src/oneTBB"
  url "https://github.com/oneapi-src/oneTBB/archive/refs/tags/v2021.12.0.tar.gz"
  sha256 "c7bb7aa69c254d91b8f0041a71c5bcc3936acb64408a1719aec0b2b7639dd84f"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "20a09dfac1334404a7da5796d116f60d21497ba80f6ab12d9f05095f72b3e5a7"
    sha256 cellar: :any,                 arm64_ventura:  "b9ab6fce05f88018e2b039ff19e379d97a6fef37157d8fdecfafbd0f0b73f19b"
    sha256 cellar: :any,                 arm64_monterey: "56f34d804f1e16c62ca755cea7f7a28fc7bf8e992ac444ad83ecc86f01d3337e"
    sha256 cellar: :any,                 sonoma:         "d4f7a8f799ab9a0ec0a493e36136d0a2f0b7b7dc2a9ad3d84098a6e705289d1a"
    sha256 cellar: :any,                 ventura:        "39d9df67e1c146705107082bff0a90584c31162574349acbceaa4a232568abe1"
    sha256 cellar: :any,                 monterey:       "c938dc2ebf9d161a4e5d9795153e1a684e869552277cb0b4e2118fc9849ddb71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22b14889248f932bf5983079a1ba9ee2602e84f9fc7655921b1d9dbda71e3163"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "swig" => :build
  depends_on "hwloc"

  def python3
    "python3.12"
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

    args = %w[
      -DTBB_TEST=OFF
      -DTBB4PY_BUILD=ON
    ]

    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static",
                    "-DBUILD_SHARED_LIBS=OFF",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install buildpath.glob("build/static/*/libtbb*.a")
  end

  test do
    # The glob that installs these might fail,
    # so let's check their existence.
    assert_path_exists lib/"libtbb.a"
    assert_path_exists lib/"libtbbmalloc.a"

    (testpath/"cores-types.cpp").write <<~EOS
      #include <cstdlib>
      #include <tbb/task_arena.h>

      int main() {
          const auto numa_nodes = tbb::info::numa_nodes();
          const auto size = numa_nodes.size();
          const auto type = numa_nodes.front();
          return size != 1 || type != tbb::task_arena::automatic ? EXIT_SUCCESS : EXIT_FAILURE;
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
