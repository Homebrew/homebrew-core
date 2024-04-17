class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://github.com/oneapi-src/oneTBB"
  url "https://github.com/oneapi-src/oneTBB/archive/refs/tags/v2021.12.0.tar.gz"
  sha256 "c7bb7aa69c254d91b8f0041a71c5bcc3936acb64408a1719aec0b2b7639dd84f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1413cb9b7515eb9399c94b5530c998b27fb5ba70b1f183d8168175178827ee8c"
    sha256 cellar: :any,                 arm64_ventura:  "2501fbee6f73642893338977ae5e9911fd7bd6e793ed1388a7826aefc0c70e11"
    sha256 cellar: :any,                 arm64_monterey: "aeca6be1f720719fd6f0dde64a85d060cfed6081d590d918128b92fc5b0254e9"
    sha256 cellar: :any,                 sonoma:         "afb040279f6198282c0348cf215d99e27dbc778c6629dc738c46b67336ed3167"
    sha256 cellar: :any,                 ventura:        "9da62541c8ccedf71ee94ecfd94eff95264d231841147534dae72347027a8dae"
    sha256 cellar: :any,                 monterey:       "b4e71f9855e51baf2309ec0bb9f0f6d721b8db67a0452bb195182fc2f9e261ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89c7a9008491b2d1b4780c4fa5f15d46bee5354de2ea96ad34d5d38b2366ee42"
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
    # Prevent `setup.py` from installing tbb4py directly into HOMEBREW_PREFIX.
    # We need this due to our Python patch.
    site_packages = Language::Python.site_packages(python3)
    inreplace "python/CMakeLists.txt", "install --prefix build -f", "\\0 --install-lib build/#{site_packages}"

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

    ENV.append_path "CMAKE_PREFIX_PATH", prefix.to_s
    ENV["TBBROOT"] = prefix
    system python3, "-m", "pip", "install", *std_pip_args, "./python"
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
