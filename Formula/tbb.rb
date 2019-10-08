class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://github.com/intel/tbb/archive/2019_U8.tar.gz"
  version "2019_U8"
  sha256 "7b1fd8caea14be72ae4175896510bf99c809cd7031306a1917565e6de7382fba"

  bottle do
    cellar :any
    sha256 "ec92c2cfbc9f7b1309c0c4304a46f4fb6b253ae06d3e36bf9cd86003127ceb6a" => :catalina
    sha256 "9f6f9d2a00fde898b8c221e4697ba83e8af8fb79bf8ab2bf7d69870b54d68bb2" => :mojave
    sha256 "8361e033d207f88a44bbe398c39f6a250b4f7e75029dddefc985947185edcedc" => :high_sierra
    sha256 "dc0cfc82511f54cd6a400c74e870cca91b56f34ec8561bfd6e57099b66899780" => :sierra
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
