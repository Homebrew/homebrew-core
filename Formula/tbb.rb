class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://github.com/intel/tbb/archive/2019_U8.tar.gz"
  version "2019_U8"
  sha256 "7b1fd8caea14be72ae4175896510bf99c809cd7031306a1917565e6de7382fba"

  bottle do
    cellar :any
    sha256 "4bfdb3fba0523b5eeec1df616bcb441e91893655bfcadfe241dbdb2da8e8450c" => :mojave
    sha256 "2abca6dd5b5ca417bd3052240b55cea2c59ea27dae1d53453d9885079893912f" => :high_sierra
    sha256 "12d98641f85d39444e1f8ebcec06ce6202dc81381d652a5ae83f19daee280567" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "python"

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
      system "python3", *Language::Python.setup_install_args(prefix)
    end

    system "cmake", "-DINSTALL_DIR=lib/cmake/TBB",
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
