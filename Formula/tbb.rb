class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://github.com/oneapi-src/oneTBB"
  url "https://github.com/intel/tbb/archive/v2020.3.tar.gz"
  version "2020_U3"
  sha256 "ebc4f6aa47972daed1f7bf71d100ae5bf6931c2e3144cf299c8cc7d041dca2f3"
  license "Apache-2.0"
  revision 1

  bottle do
    cellar :any
    sha256 "9a6b1cbf0b9f20d05075d9c7c905f7e06bf91c0dd7f5a0b7d46f0761fdb86097" => :big_sur
    sha256 "33b261262efc28bb46c9aa4ff6ae74bc51033cc9f5877c3312a52af07130d534" => :arm64_big_sur
    sha256 "e73f880d133b99c5e30120df768cff884d5d66f93f4e84bfc8937f37f9e0b614" => :catalina
    sha256 "b026eb8322c7984cdd1f5313ffd866c6d41a556ad8d7ebf1e713786724d83675" => :mojave
    sha256 "ccf240dbcb30bfb33736130c77b7afbb12a8ca4208cc8244f66943ce6c0307d1" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "python@3.9"

  # Remove when upstream fix is released
  # https://github.com/oneapi-src/oneTBB/pull/258
  patch do
    url "https://github.com/oneapi-src/oneTBB/commit/86f6dcdc17a8f5ef2382faaef860cfa5243984fe.patch?full_index=1"
    sha256 "d62cb666de4010998c339cde6f41c7623a07e9fc69e498f2e149821c0c2c6dd0"
  end

  def install
    compiler = (ENV.compiler == :clang) ? "clang" : "gcc"
    system "make", "tbb_build_prefix=BUILDPREFIX", "compiler=#{compiler}"
    lib.install Dir["build/BUILDPREFIX_release/*.dylib"]

    # Build and install static libraries
    system "make", "tbb_build_prefix=BUILDPREFIX", "compiler=#{compiler}",
                   "extra_inc=big_iron.inc"
    lib.install Dir["build/BUILDPREFIX_release/*.a"]
    include.install "include/tbb"

    cd "python" do
      ENV["TBBROOT"] = prefix
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
    end

    system "cmake", *std_cmake_args,
                    "-DINSTALL_DIR=lib/cmake/TBB",
                    "-DSYSTEM_NAME=Darwin",
                    "-DTBB_VERSION_FILE=#{include}/tbb/tbb_stddef.h",
                    "-P", "cmake/tbb_config_installer.cmake"

    (lib/"cmake"/"TBB").install Dir["lib/cmake/TBB/*.cmake"]
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <tbb/task_scheduler_init.h>
      #include <iostream>

      int main()
      {
        std::cout << tbb::task_scheduler_init::default_num_threads();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-ltbb", "-o", "test"
    system "./test"
  end
end
